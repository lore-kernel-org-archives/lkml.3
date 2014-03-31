Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaCaO4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:56:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaCaO4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:56:43 -0400
Date: Mon, 31 Mar 2014 07:56:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, hch@infradead.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/3] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Message-ID: <20140331145625.GA10791@infradead.org>
References: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:53:31PM +0900, Namjae Jeon wrote:
> This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
> As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
> in between the file within the range specified by offset and len. User can
> write new data in this space. e.g. ads.
> Like collapse range, currently we have the limitation that offset and len
> should be block size aligned for both XFS and Ext4.

Btw, I remember Samsung also had an ioctl for XFS to split a file into
two without moving the data, do you plan to submit that one as well?


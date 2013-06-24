Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3FXHHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:07:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3FXHHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:07:09 -0400
Date: Mon, 24 Jun 2013 00:06:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <esandeen@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
        Namjae Jeon <linkinjeon@gmail.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "a.sangwan@samsung.com" <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Message-ID: <20130624070656.GA20166@infradead.org>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
 <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
 <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
 <20130624024459.GJ29376@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624024459.GJ29376@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 12:44:59PM +1000, Dave Chinner wrote:
> various DVR companies shipping equivalent ioctl-based functionality
> for XFS filesystems to both insert and remove chunks in video
> streams, but I've never been able to find the code for it anywhere.

Samsung does this, also for UDF.  Namjae, could you please submit these
two as well, including a proper VFS interface?


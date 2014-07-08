Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaGHMPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:15:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaGHMPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:15:04 -0400
Date: Tue, 8 Jul 2014 05:15:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luk?? Czerner <lczerner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com
Subject: Re: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Message-ID: <20140708121500.GA518@infradead.org>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 08:59:49PM +0900, Namjae Jeon wrote:
> This patch implements fs ioctl's IOC_MOV_DATA for XFS.

Shouldn't this share code with the XFS_IOC_SWAPEXT implementation?


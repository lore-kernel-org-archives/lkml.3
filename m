Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaE1MNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:13:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaE1MNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:13:41 -0400
Date: Wed, 28 May 2014 05:13:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 05/12] scsi/NCR5380: fix build failures when debugging is
 enabled
Message-ID: <20140528121339.GA29126@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004214.102469994@telegraphics.com.au>
 <20140528095015.GE26617@infradead.org>
 <alpine.LNX.2.00.1405282207580.31798@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405282207580.31798@nippy.intranet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:09:33PM +1000, Finn Thain wrote:
> [PATCH v2 05/12] scsi/NCR5380: fix build failures when debugging is enabled
> [PATCH v2 06/12] scsi/NCR5380: fix dprintk macro usage and definition
> [PATCH v2 09/12] scsi/NCR5380: fix and standardize NDEBUG macros
> 
> And several patches in the v2 submission had some acked-by tags added.
> 
> The v2 series is the one to merge (but I think James intends to do that).

I've pulled this version into the for-3.16 drivers tree I'm collection
for james:

  http://git.infradead.org/users/hch/scsi-queue.git/shortlog/refs/heads/drivers-for-3.16

  git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.16

Can you send incremental changes if needed?


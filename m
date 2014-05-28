Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaE1Pxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:53:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbaE1Pxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:53:38 -0400
Date: Wed, 28 May 2014 08:53:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] scsi/NCR5380: dprintk macro
Message-ID: <20140528155336.GB14981@infradead.org>
References: <alpine.LNX.2.00.1405290020570.3539@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405290020570.3539@nippy.intranet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:43:43AM +1000, Finn Thain wrote:
> 
> This is the delta between the two submissions:
> [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include structure
> and
> [PATCH v2 00/12] scsi/NCR5380: fix debugging macros and #include structure
> 
> The macro definition changes were discussed on the mailing list during 
> review. The idea is to get the compiler to check the parameters of 
> disabled printk() calls so that the debugging code doesn't rot again.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Thanks a lot Finn!

> I know the whitespace is wrong throughout these drivers but when I put 
> this patch series together it seemed best to defer the whitespace cleanup. 
>(I still intend to do that cleanup.)

Yes, I ignored the whitespace warnings in the debug macro cleanups.  I
fixed them up for the "newly" added code in the sun3 driver merge.


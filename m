Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaE1JwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:52:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaE1JwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:52:11 -0400
Date: Wed, 28 May 2014 02:52:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 08/12] scsi/NCR5380: adopt dprintk()
Message-ID: <20140528095210.GH26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004214.992467108@telegraphics.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318004214.992467108@telegraphics.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:20AM +1100, Finn Thain wrote:
> All NCR5380 drivers already include the NCR5380.h header. Better to
> adopt those macros rather than have three variations on them.
> 
> Moreover, the macros in NCR5380.h are preferable because the atari_NCR5380
> and sun3_NCR5380 versions are inflexible. For example, they can't accomodate
> dprintk(NDEBUG_MAIN | NDEBUG_QUEUES, ...)
> 
> Replace the *_PRINTK macros from atari_NCR5380.h and sun3_NCR5380.h with
> the equivalent macros from NCR5380.h.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

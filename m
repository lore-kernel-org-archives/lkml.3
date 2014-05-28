Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaE1Jzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:55:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaE1Jzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:55:46 -0400
Date: Wed, 28 May 2014 02:55:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 12/12] scsi/NCR5380: merge sun3_scsi_vme.c into
 sun3_scsi.c
Message-ID: <20140528095544.GL26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004216.172443207@telegraphics.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318004216.172443207@telegraphics.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:24AM +1100, Finn Thain wrote:
> The sun3 drivers suffer from a whole bunch of duplicated code. Fix this
> by following the g_NCR5380_mmio example. (Notionally, sun3_scsi relates to
> sun3_scsi_vme in the same way that g_NCR5380 relates to g_NCR5380_mmio.)
> 
> Dead code is also removed: we now have working debug macros so
> SUN3_SCSI_DEBUG is undesirable. Dead code within #ifdef OLD_DMA is also
> dropped, consistent with sun3_scsi_vme.c.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

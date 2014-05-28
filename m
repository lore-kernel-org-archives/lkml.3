Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaE1JzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:55:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaE1JzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:55:16 -0400
Date: Wed, 28 May 2014 02:55:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 11/12] scsi/NCR5380: reduce depth of sun3_scsi nested
 includes
Message-ID: <20140528095515.GK26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004215.872456456@telegraphics.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318004215.872456456@telegraphics.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:23AM +1100, Finn Thain wrote:
> Move the #include "NCR5380.h" out of the sun3_scsi.h header file and into
> the driver .c files, like all the other NCR5380 drivers in the tree.
> 
> This improves uniformity and reduces the depth of nested includes. The
> sequence of #include's, #define's and #if's no longer does my head in.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

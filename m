Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaHSRKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:10:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:41333 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaHSRKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:10:18 -0400
Date: Tue, 19 Aug 2014 12:12:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, DL-MPTFusionLinux@lsi.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: message: fusion: Simplify rounding
Message-ID: <20140819171215.GA12722@infradead.org>
References: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:56:20PM +0200, Rasmus Villemoes wrote:
> Rounding up to a multiple of 4 should be done using the ALIGN
> macro. As a bonus, this also makes the generated code smaller.
> 
> In GetIocFacts(), sz is assigned to a few lines below without being
> read in the meantime, so it is ok that it doesn't end up with the same
> value as facts->FWImageSize.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reviewed-by: Joe Lawrence <joe.lawrence@stratus.com>

Thanks, applied to the drivers-for-3.18 branch.


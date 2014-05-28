Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaE1Juo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:50:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaE1Jum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:50:42 -0400
Date: Wed, 28 May 2014 02:50:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 06/12] scsi/NCR5380: fix dprintk macro usage and
 definition
Message-ID: <20140528095041.GF26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004214.402473367@telegraphics.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318004214.402473367@telegraphics.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:18AM +1100, Finn Thain wrote:
> There are three implementations of the core NCR5380 driver and three sets
> of debugging macro definitions. And all three implementations use the
> NCR5380.h header as well.
> 
> Two of the definitions of the dprintk macro accept a variable argument list
> whereas the third does not. Standardize on the variable argument list.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

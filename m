Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813AbaESRZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:25:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbaESRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:25:17 -0400
Date: Mon, 19 May 2014 10:25:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] wd719x: Introduce Western Digital WD7193/7197/7296
 PCI SCSI card driver
Message-ID: <20140519172516.GA10042@infradead.org>
References: <201404012303.01200.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404012303.01200.linux@rainbow-software.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 11:03:00PM +0200, Ondrej Zary wrote:
> Introduce wd719x, a driver for Western Digital WD7193, WD7197 and WD7296 PCI
> SCSI controllers based on WD33C296A chip.
> Tested with WD7193 card.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>


Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

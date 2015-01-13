Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbbAMQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:28:24 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42882 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbbAMQ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:28:21 -0500
Date: Tue, 13 Jan 2015 18:28:12 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Jisheng Zhang <jszhang@marvell.com>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: use {readl|writel}_relaxed instead of
 readl/writel
Message-ID: <20150113162812.GA2227@tarshish>
References: <1418279201-3886-1-git-send-email-jszhang@marvell.com>
 <20150113143654.GG7660@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113143654.GG7660@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Tue, Jan 13, 2015 at 03:36:54PM +0100, Wolfram Sang wrote:
> > The driver does not perform DMA, so it's safe to use the relaxed version.
> > From another side, the relaxed io accessor macros are available on all
> > architectures now, so we can use the relaxed versions instead.
> 
> Can the designware core make use of DMA in theory?

According to the "DesignWare DW_apb_i2c Databook" version I have it can 
(optionally).

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

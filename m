Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaCYNLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:11:46 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49352 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaCYNLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:11:45 -0400
Date: Tue, 25 Mar 2014 13:11:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, computersforpeace@gmail.com, dwmw2@infradead.org
Subject: Re: [RFC 00/47] mtd: nand: Add new driver supporting ST's BCH h/w
Message-ID: <20140325131139.GB24823@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <20140325125050.GB665@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140325125050.GB665@arch.cereza>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Ezequiel Garcia wrote:

> Hi Lee,
> 
> On Mar 25, Lee Jones wrote:
> > 
> > This patch-set was written against kernel version v3.4, but applies
> > cleanly to v3.13-rc7 which it is currently based. I understand that
> > the core has changed significantly since and that some of the
> > infrastructure this driver provides is now available either through
> > the framework or similar means. I'm looking for someone with inside
> > knowledge to draw attention to those areas so we can align with the
> > most recent API.
> > 
> 
> Please push a git branch. It will be nice to have a way of seeing the 'big
> picture' without applying the 47 patches.

Sure:

  git://git.linaro.org/people/lee.jones/linux-3.0-ux500.git tb-st-mtd-nand-bch

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

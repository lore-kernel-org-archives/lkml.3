Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaIYKu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:50:56 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:48380 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaIYKun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:50:43 -0400
X-Auth-Info: yarcQfa42f+MYDbljXxJV8nwD2ndZQd+jyf6rANL7o4=
From: Marek Vasut <marex@denx.de>
To: Yuan Yao <yao.yuan@freescale.com>
Subject: Re: [PATCH v8 0/2] i2c: imx: add DMA support for freescale i2c driver
Date: Thu, 25 Sep 2014 12:23:54 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: wsa@the-dreams.de, LW@karo-electronics.de, mark.rutland@arm.com,
        fugang.duan@freescale.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
References: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
In-Reply-To: <1411632689-31531-1-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409251223.54218.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2014 at 10:11:27 AM, Yuan Yao wrote:
> Changed in v8:
> - some minor fixes for coding style.
> - unsetting I2CR_DMAEN immediatelly when failed in DMA mode.

Brief skim over the patch doesn't show any dangling problems.

Reviewed-by: Marek Vasut <marex@denx.de>

btw. the U-Boot output is completely irrelevant, it only points out you use 
outdated version, so please keep only the relevant output. Also, I would 
recommend you to trim the responses to patches with [...] so one doesn't have to 
scroll through a wall of old text, but can easily find the relevant portions.

Best regards,
Marek Vasut

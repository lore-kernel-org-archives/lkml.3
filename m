Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340Ab3DIUiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:38:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935899Ab3DIUh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:37:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/8] dmaengine: ste_dma40: Actually write the runtime configuration to registers
Date: Tue, 9 Apr 2013 22:37:49 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365532783-27425-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092237.50057.arnd@arndb.de>
X-Provags-ID: V02:K0:OU5Udga6eMHkFgBdoA2DOM5LCzaTntqqkT6SSpKdp4i
 PEM/dW4f3AReGPLgfJZnxadu5aNecMIceP0weu4V2GYsl3fQuR
 142Uh/ZUXf+QUrp6jI+8PDmiCGPo1WiisCx1fT8Zszd+gTt9An
 1gYnW0nzzyayhZ2J6rx/VtiN/AmX7yqsYEuhysr5DSBZRizVn7
 D6BReuw/fPvkrnEjuTn9majkZdjl0QZdE9949msnd53Gt+BDW6
 Fb0VAAHmicPgtjuRgJx0O/2YfsjLPfNJRISNiT3FJTwOcE6rJf
 vPQEM2nPRQsdzyEleheaq1pv1IIO2cbn/J5hPGaMRvLMfpw3lZ
 0vWIGPceK5FPppuf35Uw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> Someone has spent a fair amount of effort writing a runtime configuration
> changing algorithm for DMA clients. However, the config appears to never
> actually make it to hardware. In order for the configuration to take hold
> we need to issue a d40_config_write(), as this is the routine which writes
> it into the hardware's registers.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3DRKvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:51:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967094Ab3DRKvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:51:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 06/32] ARM: ux500: Strip out duplicate USB DMA configuration
Date: Thu, 18 Apr 2013 12:51:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-7-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366279934-30761-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181251.44758.arnd@arndb.de>
X-Provags-ID: V02:K0:1+YQiicrXnXnFyY9fXY7wSE8yDOpqWwYWRFkBuaIGPW
 HE3nJ7Goiba/HV5GYB9GIWgnWMgg4mXsBMcfG7wXCbqCS52Yg5
 vCW8sZ5rAqR5dEDdH6woy/yrOMi8KHMrVinEj3nYALQk52/Prv
 pOSBKWTxWEV7F0FHEFx05e2IyZ/dNxdYuMiyi88u5ZHOJzAnHw
 gU1XpISPMCZNB7C1poyyVP4AzwDcapAe1euyDymGLVsJYCYdav
 n3pD9n9XZDg6X61g0J8l5v5SfWYbQFUZrAXWqpZkMsf7rJMSXf
 UHmQQYkTbdwaaQgIR5U2H8DTBJhKtpW6ZjMQMEutw36UT9TycQ
 ewZRPYo8ikEWSI4X2+2U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Lee Jones wrote:
> For the moment at least, the TX and RX channels for DB8500 USB are
> identical, so this patch generalises them into a single structure
> and passes it twice. Once as the TX and again for the RX configuration.
> We're keeping the infrastructure the same i.e. passing the TX and RX
> separately in case they start to differ on latter incarnations of the
> platform.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

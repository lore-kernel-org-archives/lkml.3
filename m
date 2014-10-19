Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaJSUQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 16:16:10 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60970 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaJSUQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 16:16:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <chris@printf.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCHv2 0/3] Remove mach/atmel-mci.h
Date: Sun, 19 Oct 2014 22:15:51 +0200
Message-ID: <2020417.En5p6XBEWH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413534398-22645-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1413534398-22645-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7jWAdmZ8sEiiIaMxzDGZ5SolSTiY9gEeFX53Qr2mkEP
 xbHGRzBGxg28KV5NxTTRx8DfGVLWPCtklEuTk/QLQByyBjXTtm
 zFYDzBom2I58HyTHXWkefZaVruRt5V18AzUGZ00K6WLLqa3KW1
 zP+eEUNMDXZImosddna4DORfUM3uNVwIbF+i+0m41B7Owuy5uD
 4JSsycPOj02dSRQyI2ntgKp+aCFjhZseOMENNOQk+RPb5OfLla
 sKGF6AvEuAAK9im2eNWZ3Uku/alS6s9Fu7zOIZByzaZX509M9N
 yYmAXqWQFkQDHYV1SG13BVdtwsjVoqawR1u1Z2ZvbI4ookvntc
 eOau3Uu06xVn8JPFhvfw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2014 10:26:35 Alexandre Belloni wrote:
> This patch series removes the uses of mach/atmel-mci.h and the files themselves.
> The final goal is to be able to switch AT91 to multiplatform.
> 
> The first patch introduces a new platform_data file and uses it in the driver.
> The two following patches remove the uses of mach/atmel-mci.h and the header
> itself from avR32 and ARM/at91.
> 
> Changes in v2:
>  - include back linux/atmel-mci.h and really remove mach/atmel-mci.h in at91sam9g45_devices.c
> 
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

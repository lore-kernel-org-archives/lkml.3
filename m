Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaIWM6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:58:17 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54560 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbaIWM6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:58:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v8 00/10] rtc: at91sam9: add DT support
Date: Tue, 23 Sep 2014 14:57:37 +0200
Message-ID: <2804695.hx0ZOj3D5K@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411471444-2764-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1411471444-2764-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cQH3JpLfzyKoeUPfAYWS6NLaVx/fF1XbCJlTf+EjU86
 vmL6QppP84a12plPp6INv7kSd6q6bS+HIEsIQXfI+2zENt50Aq
 ikpZ7Olv95Dhn0h4RL/ov7JwbatJS+f+aDmaxBimLD9ttoRciu
 2QKeHzzojXN41vnfl9MxzcDMpvtbmcfUxqLqQu5e1FkAfEd4Ec
 LYP8GDY4knNMBOt5ZL3Q21BDyzozgUju+4FySz7hEifV1AYau5
 jXfO1Gn0PPKTQU0jQKAYnFuiFniYgSpTTMIXUEsdmQ9OMJ3ptz
 BJptsBScIXiAp/KuemBw1rdm6ZlnrMVL7unRGXywZG8wDa/w8j
 jrJ8CmFUVoNnNorsZxdA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 13:23:54 Boris BREZILLON wrote:
> 
> This patch series adds DT support to the atmel at91sam9 RTC driver.
> 
> It also removes any machine specific inclusions to prepare the migration
> to multi platform kernel support, and retain the slow clock to prevent
> the CCF from disabling it at the end of boot.
>   
> 

Looks good to me, please add

Acked-by: Arnd Bergmann <arnd@arndb.de>

once you have addressed the remaining comments from Johan and me.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3GBFkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:40:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45578 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3GBFkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:40:51 -0400
Message-ID: <51D267BE.8090605@ti.com>
Date: Tue, 2 Jul 2013 11:10:14 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
CC: <khilman@linaro.org>, <tony@atomide.com>, <b-cousson@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/4] davinci: da8xx/omap-l1: Remove hard coding of rtc
 device wakeup
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com> <1372412109-986-3-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1372412109-986-3-git-send-email-gururaja.hebbar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/28/2013 3:05 PM, Hebbar Gururaja wrote:
> Since now rtc-omap driver itself calls deice_init_wakeup(dev, true),
> duplicate call from the rtc device registration can be removed.
> 
> This is basically a partial revert of the prev commit
> 
> commit 75c99bb0006ee065b4e2995078d779418b0fab54
> Author: Sekhar Nori <nsekhar@ti.com>
> 
>     davinci: da8xx/omap-l1: mark RTC as a wakeup source
> 
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>

Subject line should be prefixed with ARM: keeping with arch/arm
convention. Otherwise looks good.

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar

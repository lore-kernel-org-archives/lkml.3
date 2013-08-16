Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3HPMGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:06:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53717 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab3HPMGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:06:41 -0400
Message-ID: <520E14C5.9090308@ti.com>
Date: Fri, 16 Aug 2013 17:32:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
CC: <khilman@linaro.org>, <tony@atomide.com>, <benoit.cousson@gmail.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V2 2/4] ARM: Davinci: da8xx/omap-l1: Remove hard coding
 of rtc device wakeup
References: <1372841225-18813-1-git-send-email-gururaja.hebbar@ti.com> <1372841225-18813-3-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1372841225-18813-3-git-send-email-gururaja.hebbar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 July 2013 02:17 PM, Hebbar Gururaja wrote:
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
> Acked-by: Kevin Hilman <khilman@linaro.org>
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> Cc: Russell King <linux@arm.linux.org.uk>

Queuing for v3.12. In subject line, please use lower case except for
acronyms and for "ARM". Also, we dont use omap-l1 to avoid confusion
with the real omaps. Just da8xx is enough. I have fixed these locally
this time.

Thanks,
Sekhar


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3FSSSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:18:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab3FSSSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:18:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH 08/15] thermal: cpu_cooling: fix stub function
Date: Wed, 19 Jun 2013 20:18:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, patches@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-9-git-send-email-arnd@arndb.de> <51C1E98B.8030503@ti.com>
In-Reply-To: <51C1E98B.8030503@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306192018.17125.arnd@arndb.de>
X-Provags-ID: V02:K0:ofwEbFuQ033sXqvmRB5zhGZ05prwfgNDqs95Vk5LlWF
 5ZEwjt/R13/ZAd/AS/FOIQbDcaMUqdulefNKGRoCA03VXTGFKQ
 cC9Bzlsf71teyV54bi22VpHD69qGw2IKvm2O7eC0uCPvhAhHOC
 GsL/igCdMVFM1EGeSUsRrIsWbIr+lJxaGQhA4iJHJMaz9Oi2XP
 Pj20Ejhc2TyoG3eh7fxHwF/MIV9hlsA9qGSXhSnEarrfUNGADZ
 xrnGRA2FDjMR0YWX4J7sEwgMJHAspBR9dChj6WguxGIxDXUic0
 GUusrXlPUB4G08aaXidqa3rID2L2YM18PLUHRwsXlRwvTBzwsj
 w3/4HQRx6QH1q6s73w7o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Eduardo Valentin wrote:
> On 31-05-2013 18:22, Arnd Bergmann wrote:
> > The function stub for cpufreq_cooling_get_level introduced
> > in 57df81069 "Thermal: exynos: fix cooling state translation"
> > is not syntactically correct C and needs to be fixed to avoid
> > this error:
> > 
> > In file included from drivers/thermal/db8500_thermal.c:20:0:
> >  include/linux/cpu_cooling.h: In function 'cpufreq_cooling_get_level':
> > include/linux/cpu_cooling.h:57:1:
> >  error: parameter name omitted  unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)  ^
> >  include/linux/cpu_cooling.h:57:1: error: parameter name omitted
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
> 
> 
> What is the status of this patch?
> 
> I believe Rui is supposed to queue this one right?
> 

Yes, that would be good. 3.10 is broken without the patch.

	Arnd

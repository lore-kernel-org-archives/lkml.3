Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab3EBQY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:24:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758873Ab3EBQY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:24:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH, RFC 10/22] mfd: ab8500: debugfs code depends on gpadc
Date: Thu, 2 May 2013 18:24:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-11-git-send-email-arnd@arndb.de> <20130502153624.GN25256@gmail.com>
In-Reply-To: <20130502153624.GN25256@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305021824.20548.arnd@arndb.de>
X-Provags-ID: V02:K0:y22UlBp3Wpgx8rqPMY6CGlw7mZ0g4sQmGeDo6nqymUz
 qpQen9xIMdwaLScILFVAku9G83XfJ5Lfw0dgvFSmKe/7YN8PKU
 1C0iQMIffd3fVVAVJnNXu0ZC+NzVmZ52hG+DEl62cbGSvdnEtT
 h6lpXTognToR3TNjcSBaZu/kN9mDRDSfI5I1fZSgYiFLHUiz8V
 Ww3uUx2aLPzPTBakgB25c8KSQ33euZuPSIknmcyN+tHHjPpKma
 eHe+TrzHVzGqM+kVHZ7liSDD00LnHEohRfRgXk+Bz1y6mo5mxh
 h5l6w6roJxyMtqCLQTUGioCw1iecnN6XxAIaJyV5tDuBEx8MST
 PyZz4q4LhzmEZfcS5HoY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Lee Jones wrote:
> > @@ -580,7 +580,7 @@ config AB8500_CORE
> >  
> >  config AB8500_DEBUG
> >         bool "Enable debug info via debugfs"
> > -       depends on AB8500_CORE && DEBUG_FS
> > +       depends on AB8500_GPADC && DEBUG_FS
> >         default y if DEBUG_FS
> >         help
> >           Select this option if you want debug information using the debug
> 
> Did you find this with ALLCONFIG out of interest.

I used "make randconfig" with this KCONFIG_ALLCONFIG file:

CONFIG_MMU=y
CONFIG_ARCH_MULTI_V7=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_PROC_FS=y
 
> Applied by the way.

Thanks!

	Arnd

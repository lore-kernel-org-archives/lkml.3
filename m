Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3AUIw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:52:58 -0500
Received: from mout.gmx.net ([212.227.15.19]:53059 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab3AUIw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:52:56 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1+ZSCkDfWeZpH+buRGZqb5IyRuCCl2LcdoVGyBJnw
	JnwJSad4r8BXCe
From: Marc Dietrich <marvin24@gmx.de>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Mark Zhang <markz@nvidia.com>, gnurou@gmail.com
Subject: Re: [PATCH 2/3] tegra: pwm-backlight: add tegra pwm-bl driver
Date: Mon, 21 Jan 2013 09:52:45 +0100
Message-ID: <2440319.UsvGAcXXBp@fb07-iapwap2>
User-Agent: KMail/4.9.5 (Linux/3.7.2-18-desktop; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50FCEFDE.8000705@gmail.com>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <1358591420-7790-3-git-send-email-acourbot@nvidia.com> <50FCEFDE.8000705@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > diff --git a/drivers/video/backlight/pwm_bl_tegra.c
> > b/drivers/video/backlight/pwm_bl_tegra.c new file mode 100644
> > index 0000000..8f2195b
> > --- /dev/null
> > +++ b/drivers/video/backlight/pwm_bl_tegra.c
> 
> So according to the filename, I think we can put all tegra boards codes
> here, right? Just like what you do for Ventana, if I wanna add support
> for cardhu, I can define similar functions -- let's say "init_cardhu",
> "exit_cardhu", "notify_cardhu" and "notify_after_cardhu", right?
> 
> But I think if we do in this way, the file will become very long soon.
> And there are a lot of redundant codes in it. So do you have any
> suggestions?

I think we (for PAZ00) will just reuse the ventana code which is sufficient 
for us. But adding "pwm-backlight-ventana" to our DTS may look a bit strange. 
On the other hand, I guess that's why the property is called "compatible".

Marc


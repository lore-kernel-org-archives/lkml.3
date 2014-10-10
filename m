Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaJJMdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:33:45 -0400
Received: from gloria.sntech.de ([95.129.55.99]:46686 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaJJMdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:33:41 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: PERIER Romain <romain.perier@gmail.com>,
        devicetree <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, robh <robh@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/4] regulator: Add helper function to get "poweroff-source" property
Date: Fri, 10 Oct 2014 14:33:23 +0200
Message-ID: <2477657.j9qmEgD9t9@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CACxGe6vmBSgGpJgJ51Ki5KbQO65GDw3kSGSxnswYMfE8OGj9gw@mail.gmail.com>
References: <1412711104-15902-1-git-send-email-romain.perier@gmail.com> <CABgxDoL2cztT6Y0oodtk4Q4jaDc1Rtx_RokxC+f0XykSojrdyg@mail.gmail.com> <CACxGe6vmBSgGpJgJ51Ki5KbQO65GDw3kSGSxnswYMfE8OGj9gw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Am Freitag, 10. Oktober 2014, 12:47:08 schrieb Grant Likely:
> What I'm more concerned about is the semantics of the property. What
> do the generic code paths gain by standardizing this property? Is it
> expected that
[seems to be missing some text in the original mail]

We currently see an influx of system-power-controller variants. While in the 
past it only was
	ti,system-power-controller

there is now already
	maxim,system-power-controller
	rockchip,system-power-controller

Romain's work would introduce "active-semi,system-power-controller", I have a 
"netronix,system-power-controller" sitting in some distant tree and there may 
be more already waiting somewhere.

So in the worst case I'd think you could expect such a property for every 
pmic-vendor in vendor-prefixes.txt ... as it seems to be a quite common use-
case these days to have the pmic handle system power on its own.


Heiko

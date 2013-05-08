Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3EHQVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:21:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3EHQVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:21:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [RFC 7/8] ARM:stih41x: Add B2000 board support
Date: Wed, 8 May 2013 18:20:23 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux@arm.linux.org.uk, olof@lixom.net, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022329-2424-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1368022329-2424-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305081820.23968.arnd@arndb.de>
X-Provags-ID: V02:K0:JGMOEIe9n+DdV0y/ELoMYYDFqnAJ/Mf/MtIK4G1vUw2
 Y0SVBZVJvJZEc4l6+1wvwRhpbi+CEOQWUdpvDZewCPwVwqls86
 tX3i3dcXlmCMC8TSw76f8SSS6D5JUyeCHp8GxMV3S9itplGBR3
 MLLXqjugigPAlCQyIm9cuZ+frSQy6eRxWp8p69WW40F56CV92w
 oK8eIcG3loAjJIEpzhz87SWLnjbyxihA7U5fcwgVCikzNQhN5G
 oeid3E/7mGQCAFzAywLdu8P7v/LpH5Gffz51PiccjNLqWNUSgR
 +qzO+n1A7tF0ZTlHjoJ6ECiAaJyMz4rtdmQkLAVLmawRnH8AU+
 gIG+wzoWGvDWj1lITwJk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
> diff --git a/arch/arm/mach-stih41x/board-dt.c b/arch/arm/mach-stih41x/board-dt.c
> index 8005f71..1f23aca 100644
> --- a/arch/arm/mach-stih41x/board-dt.c
> +++ b/arch/arm/mach-stih41x/board-dt.c
> @@ -63,6 +63,8 @@ void __init stih41x_dt_init(void)
>  }
>  
>  static const char *stih41x_dt_match[] __initdata = {
> +       "st,stih415-b2000",
> +       "st,stih416-b2000",
>         NULL
>  };

I probably wouldn't bother listing all the boards here. Just make sure
the .dts file lists both the name of the board and of the soc in
its compatible property, and list all the SoCs here that you can boot on.

	Arnd

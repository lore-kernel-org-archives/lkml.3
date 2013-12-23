Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3LWJy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 04:54:29 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63712 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3LWJy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 04:54:27 -0500
MIME-Version: 1.0
In-Reply-To: <1381937948-27057-1-git-send-email-nm@ti.com>
References: <1381937948-27057-1-git-send-email-nm@ti.com>
Date: Mon, 23 Dec 2013 15:24:26 +0530
X-Google-Sender-Auth: Y9yOmswX-HaHED35qVrGywssHJg
Message-ID: <CAOh2x==pT=ASrocV=dRKgFECyWbxN3pnzo9a4026szPGLXfbqg@mail.gmail.com>
Subject: Re: [PATCH V7 0/8] ARM: OMAP3+: support cpufreq-cpu0 for device tree boot
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        sanjay.rawat@linaro.org, Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 9:09 PM, Nishanth Menon <nm@ti.com> wrote:
> PandaBoard-ES (OMAP4460): http://pastebin.com/qQCmA2ng

Hi Nishanth,

A colleague of mine (Sanjay), was trying mainline on panda board. And
wasn't able to get cpufreq-cpu0 working with it. Even your log also
reports its broken as it can't get any regulator information..

He is getting this:

cpufreq_cpu0: failed to get cpu0 regulator: -19
cpufreq_cpu0: failed to get cpu0 clock: -2
cpufreq-cpu0: probe of cpufreq-cpu0.0 failed with error -2

Can you please help him out?

--
viresh

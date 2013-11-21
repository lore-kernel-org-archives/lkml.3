Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3KUHlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 02:41:50 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:43974 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KUHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 02:41:48 -0500
MIME-Version: 1.0
In-Reply-To: <528CCE42.2060307@ti.com>
References: <1384568535-26611-1-git-send-email-nm@ti.com>
	<20131116134445.GI11014@S2101-09.ap.freescale.net>
	<CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>
	<528A27F8.3070402@ti.com>
	<20131118155753.GU11014@S2101-09.ap.freescale.net>
	<528A4340.3020508@ti.com>
	<20131119022133.GB18434@S2101-09.ap.freescale.net>
	<CAKohpok_yRZr-XQEC+w8PLN+ZyW83uijFyZrDM1LB8G2X4h-fg@mail.gmail.com>
	<528B72C1.5060006@ti.com>
	<CAKohpo=hzCSuQBGreRStzkOuH6aFiZKTtK9SF+_eGEajkwSXEA@mail.gmail.com>
	<528B7CE5.5040502@ti.com>
	<CAKohponO7M6rYoPt=ePNTZh=y+iU=BEbFWBqxr1JQPbVptvgXA@mail.gmail.com>
	<528B884C.7070908@ti.com>
	<CAKohpo=brpnLe68ExPRPg9h5ABMhg+GS85Ebn-+S5-vWaStrPQ@mail.gmail.com>
	<528BA355.4040008@ti.com>
	<528C478C.1070901@linaro.org>
	<528CCE42.2060307@ti.com>
Date: Thu, 21 Nov 2013 13:11:47 +0530
Message-ID: <CAKohpo=CaNMmU0wPH+WC5mKHZG1LQ-cSG+BS-oexAHnTuOcHVA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2013 20:29, Nishanth Menon <nm@ti.com> wrote:
> With the current governors that we have in upstream, the only one of
> my concern has been userspace governor, but based on your comment
> earlier in the thread, this is considered an non-issue since userspace
> must trigger transition. However, this does put the SoC at risk
> depending on distro and custom governors used.
>
> If the opinion is that we dont care about these, well.. I can end my
> complaints and depend on the stats to tell me if an unknown frequency
> was ever attempted for debug (even though I might personally not be
> too excited about it).

I wouldn't say that I was against this patch, but it looked like we could live
without it as well.. But I also feel that there is some amount of uncertainty
here and specially with userspace governor..

So, just see the patch which I have floated as replacement for few of the
patches we have been talking about..

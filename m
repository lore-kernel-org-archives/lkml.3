Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3KYKOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:14:09 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40588 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3KYKOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:14:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomEL8aU_ETaHFG_G8mhYMZc6M6x7i4m+McozP=i7Fzz5A@mail.gmail.com>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
	<CAKohpo=RWi1nRUJq4qx8K+Y7swMDaqwEOH24-KfBCMgdbW=hMQ@mail.gmail.com>
	<528FB2EC.2020202@wwwdotorg.org>
	<2065978.h16hV1Cgky@vostro.rjw.lan>
	<CAKohpomEL8aU_ETaHFG_G8mhYMZc6M6x7i4m+McozP=i7Fzz5A@mail.gmail.com>
Date: Mon, 25 Nov 2013 15:44:02 +0530
Message-ID: <CAKohpompkiUqOati4B8F0HqN2eTMEADm01SnUuE0_GxnTAWJdQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] cpufreq: Change freq before suspending governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Kukjin Kim <kgene@kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2013 09:58, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Giving cpufreq-drivers a chance to do whatever they want looks to be
> correct. So, maybe prepare() or suspend_prepare() for them can be
> implemented.

I have used the existing infrastructure here, i.e. suspend/resume callbacks
for drivers.. As we don't need two suspend calls now..

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3K2D0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 22:26:14 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:33520 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3K2D0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 22:26:09 -0500
MIME-Version: 1.0
In-Reply-To: <1781198.iCUX9ZdW7W@vostro.rjw.lan>
References: <28d493f20239a242a7b26dfe1efed40d83bf1e10.1385523340.git.viresh.kumar@linaro.org>
	<3057132.zHNVNQZ8pP@vostro.rjw.lan>
	<CAKohpondYbBeObUJJqNZLe04dmN9tLMZv9KrjzqLr2NDorRtLw@mail.gmail.com>
	<1781198.iCUX9ZdW7W@vostro.rjw.lan>
Date: Fri, 29 Nov 2013 08:56:08 +0530
Message-ID: <CAKohpomA9r5a4GkfA-Huh0ectc-hXjSxcdLkJhF6DZvL22yY4w@mail.gmail.com>
Subject: Re: [PATCH V4] cpufreq: suspend governors on system suspend/hibernate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2013 01:59, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> So I'm reading this as "the version of the patch in bleeding-edge is OK".
>
> I hope that really is the case. :-)

Yeah, that's correct.

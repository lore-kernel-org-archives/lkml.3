Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaGBDcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:32:16 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49383 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaGBDcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:32:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140701220038.32686.81633@quantum>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
	<e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
	<53AB1CC1.4010907@codeaurora.org>
	<CAKohpo=Q7eWNwcK6KF9_U-zD0g=96QHW9hiQupLpV5GqoWE+mA@mail.gmail.com>
	<53ACB568.4000903@codeaurora.org>
	<20140627015354.32686.83046@quantum>
	<CAKohponvN3rAvJrfi4TojFcq5gq7r2oNE4Q0_NtwBHmEZ8waBA@mail.gmail.com>
	<CAKohpo=dgSW551yzqjAV2_opw_4naqFEWpwUz9ktkGgR5vCBZA@mail.gmail.com>
	<CABGGiswMuofH5WRh4jgwh1=CV+fEXM_Ec3+WNwThbuMLVxsdcg@mail.gmail.com>
	<CAKohpokaVPn7yNPNAGrE6juGaOYuxZvVsbmkOZmyi9rDub6t7g@mail.gmail.com>
	<20140701220038.32686.81633@quantum>
Date: Wed, 2 Jul 2014 09:02:13 +0530
Message-ID: <CAKohponkzkpDQb3J2061bxpjtyPskJK1o0OB0hT2R7=RvuKLXw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <rob.herring@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org, Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 July 2014 03:30, Mike Turquette <mturquette@linaro.org> wrote:
> I can't help but think this is a pretty ugly solution. Why not specify

Thanks :)

> the nature of the cpu clock(s) in DT directly? There was a thread
> already that discussed adding such a property to the CPU DT binding but
> it seems to have gone cold[1]. Furthermore my mailer sucks and I see now
> that my response to that thread never hit the list due to mangled
> headers. Here is a copy/paste of my response to the aforementioned
> thread:

Atleast I received it.

Yes, I do agree that we need to get this from the DT in more elegant
way but it is going to take some time in doing that, and probably some
people are working on it as that might be used in scheduler-cpufreq
coordination as well..

For now we can go ahead and make it workable, even if it isn't that
elegant and update it later on.

Thanks for your inputs.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab3EXIar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:30:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25220 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760059Ab3EXIaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:30:16 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-eb-519f25169717
Date: Fri, 24 May 2013 10:30:07 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130524103007.7bb206ee@amdc308.digital.local>
In-reply-to: <CAKohpoksymD76rDvg_+PwU7r3JXp1oydHBbJE4-y6TBHOomZHg@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
 <20130522122700.104ca5cd@amdc308.digital.local>
 <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
 <20130522164453.29cd3a7d@amdc308.digital.local>
 <20130524075640.0a5b80ff@amdc308.digital.local>
 <CAKohpoksymD76rDvg_+PwU7r3JXp1oydHBbJE4-y6TBHOomZHg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQV0x1fmBBr1vDSyeNv1gt5j3Wdai
	8+wTZos3j7gtLu+aw2bxufcIo8XtxhVsFv0Le5ksOo58Y7bY+NXDgcvjzrU9bB7rpr1l9ujb
	sorR49HiFkaPz5vkAlijuGxSUnMyy1KL9O0SuDKWTn/EUnBctuLNsvWMDYw7RbsYOTkkBEwk
	tt/4zAhhi0lcuLeerYuRi0NIYDqjxNnlL6CcdiaJo31fWUGqWARUJXb//wrWwSagJ/H57lOm
	LkYODhEBLYmXN1NB6pkFLjBJnLo0iwmkRlggXeLfti4wm1fAWuLW1i4WEJtTIFhizdtNUAs2
	M0vM33oDbAG/gKRE+78fzBAn2Umc+7SBHaJZUOLH5HtgzcxAyzZva2KFsOUlNq95yzyBUXAW
	krJZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Mp5J7WBc2WBxiFGAg1GJ
	h3eGzrxAIdbEsuLK3EOMEhzMSiK8s/jmBwrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgk
	kJ5YkpqdmlqQWgSTZeLglGpg3JXwtTJ52pwMh5KTCZF/pja/6Fy4gm1pgZKm3NFj/6qDj724
	4n1h4WKDzSbSUWu2npOKymE1Wnj9yN0FCle25hzXqtVX3/zGXEVI6fcLR7FFM5Vu3Fv76vrr
	fyfFeb0P3vm9327OTMcpWrczFDorNGSyOSKKzCR2TmoLvlHluTphJqM2b2OWiBJLcUaioRZz
	UXEiAG/DJt+IAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 24 May 2013 11:26, Lukasz Majewski <l.majewski@samsung.com> wrote:
> >> > On 22 May 2013 15:57, Lukasz Majewski <l.majewski@samsung.com>
> > As you wished, I've provided relevant data for overclocking.
> >
> > Would you be so kind and comment on them?
> 
> I was about to reply ... was busy with some other backlog :)
> 
> >> Test HW Exynos4412 (4 Cores):
> >> Kernel 3.8.3
> >>
> >> Ondemand max freq: 1.4 GHz
> >> Overclock max freq: 1.5 GHz
> >>
> >>
> >> Ondemand improvement with and without overclocking (called by us
> >> TurboBoost - TB):
> >>
> >> Dhrystone has been built according to:
> >> http://zenit.senecac.on.ca/wiki/index.php/Dhrystone_howto
> >> It's Makefile is also attached.
> >> ------------------------------------------------
> >>
> >> Dhrystone     # of Threads
> >>               1       2       3       4
> >> ondemand      2054794 2061855 2097902 2090592
> >> ondemand + TB 2290076 2205882 2281368 2290076
> >>
> >> Improvement:  10%     7%      8%      9%
> >> -------------------------------------------------
> >>
> >> Electric charge [C]
> >> (Avg) [A] * [second]  # of Threads
> >>               1       2       3       4
> >> ondemand      1,334   1,837   2,296   3,096
> >> ondemand + TB 1,401   2,2025  2,907   4,34976
> >>
> >> Power cost:   5%      17%     21%     29%
> >> -------------------------------------------------
> >>
> >> Execution time [second]       # of Threads
> >>               1       2       3       4
> >> ondemand      2,827   2,8     2,787   2,872
> >> ondemand + TB 2,622   2,694   2,667   2,76
> >>
> >>
> >> Speedup:      -7%     -4%     -4%     -4%
> >>
> >> -------------------------------------------------
> >>
> >> "Real life" example:
> >> time tar -czf linux-3.9.1.tar.gz linux-3.9.1/
> >>
> >>               Avg current[mA]         Time[s]
> >> Ondemand:     460                     153
> >> Ondemand + TB:        512                     144
> >>
> >> Result:               +10%                    -6%
> >>
> >> Conclusion:
> >>
> >> The main use case for TB is to speed up execution of tasks packed
> >> to one core. Other cores are then in IDLE state.
> >>
> >> For a single core we can safely overclock, since we will not exceed
> >> its power consumption and thermal limits.
> 
> Hmm... So its ultraclear that higher clock rates have given us better
> performance numbers, obviously at the cost of power.

Yep, no magic here.

> 
> Now, why don't we simply add this high end frequency in the available
> frequencies list? And then ondemand can set it whenever the load is
> high? Why do we need additional core support for it?

The overclock frequency (1.5 GHz) is possible to set as an ordinary,
available frequency (policy->max) for ondemand. 

Unfortunately with our load patterns, this frequency rapidly increases
internal chip temperature (chip goes out of available power/thermal
dissipation range), and consumes extra power when not needed. 

The core idea with overclock is to increase ("boost") the frequency
when conditions allow to do it (for example load is affined to a single
core, other are idle). Then we will not exceed power/thermal budget, but
increase performance (and even save power).


Overclocking is efficiently utilized by LAB, which relies on a number of
idle cpus. Thus, we can easily asses if we can enable it. 

I also foresee potential use of overclocking, when scheduler will take a
major role of power saver for mobile (ARM) linux. Since it will try to
pack as much tasks as possible to a single core - it will need a
framework/API to "boost" their execution.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland | Linux Platform Group

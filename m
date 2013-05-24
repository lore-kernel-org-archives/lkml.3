Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab3EXIQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:16:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22723 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3EXIQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:16:32 -0400
X-AuditID: cbfee691-b7fef6d000002d62-c3-519f21de0ba1
Date: Fri, 24 May 2013 08:16:30 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application
 Booster governor - tests results
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>
Cc: =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>,
        "Rafael J. Wysocky" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lukasz Majewski <l.majewski@majess.pl>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20130524081622735@myungjoo.ham
Msgkey: 20130524081622735@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130524081622735@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <27081278.28361369383389496.JavaMail.weblogic@epml20>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42JZI2JSqHtPcX6gQdM8Q4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXx4fcKxoI58hVt+8+yNDBukOti5OQQElCXWLTkJBuILSFgIvHs
	80oWCFtM4sK99UBxLqCapYwSX+duYO1i5AArWvzHHKJ3PqPEkZUWIDaLgKpE7/xONpASNgE9
	iZmfk0HCwgKZEntfX2AHsUUEoiQ2b3/JDDKSWWAxs8S9U/9YIeYoSazZ9wpsL6+AoMTJmU+g
	blCVOLpgMthaXgE1iStXUyDCEhKzpl9ghbB5JWa0P4Uql5OY9nUNM4QtLXF+1gZGmFcWf38M
	FeeXOHZ7BxPEJ7wST+4Hw4zZvfkLNBQEJKaeOQjVqiWxu+Mm1Co+iTUL37LAjNl1ajkzTO/9
	LXOZQGxmAUWJKd0P2SFsLYkvP/axofoK5BNHiasnSicwKs9CkpmFpHsWkm5kNQsYWVYxiqYW
	JBcUJ6UXmeoVJ+YWl+al6yXn525iBCaE0/+eTdzBeP+A9SHGZGCETGSWEk3OByaUvJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw9v5WM0i5+G++
	jYG3yZGo555CZmJCHKUaUfImK6eYRqseELhhOJEhZPoDfwVurgW9ypbux/NXNXZVfNKN5SqY
	n68xUTLrytln1Wk2R8rq9x1RDj/y7K37ctHJfNy3MgtKAkNS2ZjeNmSvD1sX+uj92t4D5SHK
	kvlT98/e4yAZcbnZ6Obpu1uUWIozEg21mIuKEwEYVPFLHgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t/t6br3FOcHGrzeo2VxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jI+
	/F7BWDBHvqJt/1mWBsYNcl2MnBxCAuoSi5acZOti5OCQEDCRWPzHHCQsISAmceHeejaIkvmM
	EkdWWoDYLAKqEr3zO8HK2QT0JGZ+TgYJCwtkSux9fYEdxBYRiJLYvP0lcxcjFwezwGJmiXun
	/rFCzFGSWLPvFQuIzSsgKHFy5hMWiF2qEkcXTGYFmckroCZx5WoKRFhCYtb0C6wQNq/EjPan
	UOVyEtO+rmGGsKUlzs/awAhz8uLvj6Hi/BLHbu9ggviKV+LJ/WCYMbs3f2GDsAUkpp45CNWq
	JbG74ybUKj6JNQvfssCM2XVqOTNM7/0tc5lAbGYBRYkp3Q/ZIWwtiS8/9rGh+grkE0eJqydK
	JzDKzUKSmYWkexaSbmQ1CxhZVjGKphYkFxQnpVcY6xUn5haX5qXrJefnbmIEp6Vni3cw/j9v
	fYhRgINRiYf3g968QCHWxLLiytxDjBIczEoivLP45gcK8aYkVlalFuXHF5XmpBYfYkwGRt9E
	ZinR5HxgyswriTc0NjYxMzG1NLEwMDUnTVhJnPdZq3WgkEB6YklqdmpqQWoRzBYmDk6pBkYJ
	tX3MuXqMzkv+XpPOcTgY77v6wAb3j/8fztrbMKF1usPhJewbGR5v3xXwcXevX4C/gc5Gv+81
	XNOZIkScXvVsdyiVl6mVyWHtmrT6/cWlZ1QVdl55abf49d/+K4ErKqQmbf8xo94qe6PcT/0v
	h1b9+/9B+4a+mKfHyj238lmaS5dx5e+wuL9WiaU4I9FQi7moOBEAkx86bY8DAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4O8GkrQ010151

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
> >> The main use case for TB is to speed up execution of tasks packed to
> >> one core. Other cores are then in IDLE state.
> >>
> >> For a single core we can safely overclock, since we will not exceed
> >> its power consumption and thermal limits.
> 
> Hmm... So its ultraclear that higher clock rates have given us better
> performance numbers, obviously at the cost of power.
> 
> Now, why don't we simply add this high end frequency in the available
> frequencies list? And then ondemand can set it whenever the load is
> high? Why do we need additional core support for it?


It is because we cannot use the frequency if there are more running cores.
We can use such frequencies only if the # cores is limited.
(We do not want conventional performance/ondemand/conservative to use
such frequencies.)


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

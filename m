Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938Ab3FSWjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:39:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43375 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935295Ab3FSWjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:39:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Xiaoguang Chen <chenxg.marvell@gmail.com>,
        Xiaoguang Chen <chenxg@marvell.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Subject: Re: [PATCH v5] cpufreq: fix governor start/stop race condition
Date: Thu, 20 Jun 2013 00:49:09 +0200
Message-ID: <2925371.ZJMOdCiC6f@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=ADC_MGpXFp-QssYS70PHwBBA6qzrWhYGEqZeeaZHLDQ@mail.gmail.com>
References: <1371114118-19488-1-git-send-email-chenxg@marvell.com> <CAFgnuDe1bUub92uE1H9Fc9U7AJCYL=WKdyDe2bg00yEr=kMEbQ@mail.gmail.com> <CAKohpo=ADC_MGpXFp-QssYS70PHwBBA6qzrWhYGEqZeeaZHLDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 08:30:11 AM Viresh Kumar wrote:
> On 19 June 2013 06:50, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
> > 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
> >> On Thursday, June 13, 2013 05:01:58 PM Xiaoguang Chen wrote:
> >>> cpufreq governor stop and start should be kept in sequence.
> >>> If not, there will be unexpected behavior, for example:
> >>>
> >>> we have 4 cpus and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
> >>
> >> Please spell cpus as "CPUs".  And please start sequences from capitals.
> >
> > Ok, thanks for the remind
> >
> >>
> >> [Yes, it *really* is a problem.]
> 
> Just wanted to know the reasoning behind it so that I can remind
> others about it and then argue :)

Well, sentences that don't start from upper-case letters don't look like
separate sentences and when I see "cpus" written like this I tend to read
it as "cups" with a typo.

Generally speaking, don't make changelogs harder to read than they have to be.

They usually are hard enough to read anyway.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

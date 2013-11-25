Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3KYLOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:14:03 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63319 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751365Ab3KYLN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:13:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, hg197@gmx.de,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Cpufreq: Change sysfs interface cpuinfo_cur_freq access privilege
Date: Mon, 25 Nov 2013 12:26:46 +0100
Message-ID: <5074010.ha99UACE9S@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5292E133.1040800@intel.com>
References: <1385348018-30525-1-git-send-email-tianyu.lan@intel.com> <CAKohponvz8CjDpMbx=BXpBv5q8d4x94No90sJWjVsTRS_Uj1jw@mail.gmail.com> <5292E133.1040800@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 01:33:39 PM Lan Tianyu wrote:
> On 2013年11月25日 12:30, Viresh Kumar wrote:
> > On 25 November 2013 08:23, Lan Tianyu <tianyu.lan@intel.com> wrote:
> >> Currently, cpuinfo_cur_freq is only accessible for root user while
> >> other cpufreq sysfs interfaces(E,G scaling_cur_freq) are available
> >> to ordinary user. This seems make no sense. This patch is to change
> >> it.
> > 
> > There is nothing wrong with the code and so this is more of a design
> > change..
> > 
> > Probably Rafael can help us here as cpufreq_cur_freq will read stuff
> > directly from hardware instead of using cached value in software.
> 
> I think so, too. I also tried to checking the reason of the privilege by
> git log but the code was there before linux kernel being migrated to git
> repository.

And it has always behaved in the same way?  Then I wouldn't change it.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

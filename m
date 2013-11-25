Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3KYFpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 00:45:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:53445 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab3KYFpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 00:45:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,765,1378882800"; 
   d="scan'208";a="439062855"
Message-ID: <5292E133.1040800@intel.com>
Date: Mon, 25 Nov 2013 13:33:39 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, hg197@gmx.de,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Cpufreq: Change sysfs interface cpuinfo_cur_freq access
 privilege
References: <1385348018-30525-1-git-send-email-tianyu.lan@intel.com> <CAKohponvz8CjDpMbx=BXpBv5q8d4x94No90sJWjVsTRS_Uj1jw@mail.gmail.com>
In-Reply-To: <CAKohponvz8CjDpMbx=BXpBv5q8d4x94No90sJWjVsTRS_Uj1jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年11月25日 12:30, Viresh Kumar wrote:
> On 25 November 2013 08:23, Lan Tianyu <tianyu.lan@intel.com> wrote:
>> Currently, cpuinfo_cur_freq is only accessible for root user while
>> other cpufreq sysfs interfaces(E,G scaling_cur_freq) are available
>> to ordinary user. This seems make no sense. This patch is to change
>> it.
> 
> There is nothing wrong with the code and so this is more of a design
> change..
> 
> Probably Rafael can help us here as cpufreq_cur_freq will read stuff
> directly from hardware instead of using cached value in software.

I think so, too. I also tried to checking the reason of the privilege by
git log but the code was there before linux kernel being migrated to git
repository.

> 
> --
> viresh
> 


-- 
Best regards
Tianyu Lan

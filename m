Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaGJLvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:51:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:60172 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaGJLvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:51:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140710114828.GA3254@pd.tnic>
References: <9e68cba2bf41923630ea93de7c3d17637f175895.1403772686.git.viresh.kumar@linaro.org>
	<20140710114828.GA3254@pd.tnic>
Date: Thu, 10 Jul 2014 17:21:43 +0530
Message-ID: <CAKohpom0Qwbj5Ma_zCE5juk=1JjbBDLZJcBXZMgnkDVPiTvRCA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: report driver's successful {un}registration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2014 17:18, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jun 26, 2014 at 02:21:30PM +0530, Viresh Kumar wrote:
>> We do report driver's successful {un}registration from cpufreq core, but is done
>> with pr_debug() and so this doesn't appear in boot logs.
>>
>> Convert this to pr_info() to make it visible in logs.
>
> And we want this because...?

So that it appears in boot logs and we know cpufreq registered properly.

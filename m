Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3ITFaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 01:30:07 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34812 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3ITFaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 01:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpom-3orEns00DC2=uk4pgV_xnfRpM1hrdyK9pjPUEgBXrA@mail.gmail.com>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org>
	<CAKohpomt+sASL=2i-v=HSkhOZhbPmnFesEfPoEqSE+WKcCfnmw@mail.gmail.com>
	<11319698.mBBnJVdnIk@vostro.rjw.lan>
	<CAE9FiQXP3DARdJYHBS8w0ATVM78Q9tGTd=8CeMJiwozBU0F_OA@mail.gmail.com>
	<CAKohpom-3orEns00DC2=uk4pgV_xnfRpM1hrdyK9pjPUEgBXrA@mail.gmail.com>
Date: Thu, 19 Sep 2013 22:30:04 -0700
X-Google-Sender-Auth: mnEn9nITmgk9IAuwyTw_9LaC54k
Message-ID: <CAE9FiQU5PD4asdE3=sBSnLK8fwPT8vK81FAOuYtAWj_3ruyS0g@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
From: Yinghai Lu <yinghai@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 9:23 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 20 September 2013 07:01, Yinghai Lu <yinghai@kernel.org> wrote:
>> Sorry,  looks like this one is not enough.
>>
>> please let me know if you prefer me send addon patch
>> or revised one.
>
> Atleast you can let us know what the problem is? And then we
> can decide on that.. But anyway, you can send a new patch
> based over latest linux-next (which will have your original patch),
> and then leave it onto Rafael to merge it or have two patches..
> (though I am quite sure he will not drop anything now, unless its
> too screwed.., at worst he might revert it..)..

looks like the crash is intermittent..., so i thought that patch fixed
the problem.
but later I found other suspicious print out.

please check new one:

https://patchwork.kernel.org/patch/2915181/

Thanks

Yinghai

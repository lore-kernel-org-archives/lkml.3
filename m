Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3ITRMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:12:34 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38928 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3ITRMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:12:32 -0400
MIME-Version: 1.0
In-Reply-To: <3290463.fBbGMovmdx@vostro.rjw.lan>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org>
	<CAKohpom-3orEns00DC2=uk4pgV_xnfRpM1hrdyK9pjPUEgBXrA@mail.gmail.com>
	<CAE9FiQU5PD4asdE3=sBSnLK8fwPT8vK81FAOuYtAWj_3ruyS0g@mail.gmail.com>
	<3290463.fBbGMovmdx@vostro.rjw.lan>
Date: Fri, 20 Sep 2013 10:12:31 -0700
X-Google-Sender-Auth: v3OZv3PB-cUCZt6-oc0T2eLTA-8
Message-ID: <CAE9FiQWm=Db4e8nYdVJzpirmV2EfKxEYYRHo6ggTtX0CY3-hhg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 6:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, September 19, 2013 10:30:04 PM Yinghai Lu wrote:
>> On Thu, Sep 19, 2013 at 9:23 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> > On 20 September 2013 07:01, Yinghai Lu <yinghai@kernel.org> wrote:
>> >> Sorry,  looks like this one is not enough.
>
> Well, I've already applied this one and it makes sense to me anyway.

you can keep that.

>
>> >> please let me know if you prefer me send addon patch
>> >> or revised one.
>> >
>> > Atleast you can let us know what the problem is? And then we
>> > can decide on that.. But anyway, you can send a new patch
>> > based over latest linux-next (which will have your original patch),
>> > and then leave it onto Rafael to merge it or have two patches..
>> > (though I am quite sure he will not drop anything now, unless its
>> > too screwed.., at worst he might revert it..)..
>>
>> looks like the crash is intermittent..., so i thought that patch fixed
>> the problem.
>> but later I found other suspicious print out.
>
> So, does it mean that the $subject patch fixes the issue for you to some
> extent, but more changes are necessary to make it go away completely?

yes.

>
>> please check new one:
>>
>> https://patchwork.kernel.org/patch/2915181/
>
> I see.
>
> I *think* we can just drop the module requesting stuff entirely, because it
> doesn't seem to work anyway and udev is handling this for us.

looks some nehalem/westmere based system may need it when they have
several SSDTs. will double check that.

Thanks

Yinghai

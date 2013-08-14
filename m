Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab3HNOoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:44:54 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:34797 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3HNOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:44:52 -0400
Date: Wed, 14 Aug 2013 16:44:49 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/37] cpufreq: at32ap: don't initialize part of policy
 that is set by core too
Message-ID: <20130814144449.GA9485@samfundet.no>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
 <6fe9b31a6e199052e0a91b38c8f6d110e9f57b28.1376486713.git.viresh.kumar@linaro.org>
 <20130814143535.GB3263@samfundet.no>
 <CAKohpo=n9o+EKkboc1hw7ms_NkNwbsJ4VvEA2cB0R7gUi-U94A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=n9o+EKkboc1hw7ms_NkNwbsJ4VvEA2cB0R7gUi-U94A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 14 Aug 2013 20:07:44 +0530 or thereabout, Viresh Kumar wrote:
> On 14 August 2013 20:05, Hans-Christian Egtvedt <egtvedt@samfundet.no> wrote:
>> Around Wed 14 Aug 2013 19:01:53 +0530 or thereabout, Viresh Kumar wrote:
>>> Many common initializations of struct policy are moved to core now and hence
>>> this driver doesn't need to do it. This patch removes such code.
>>>
>>> Most recent of those changes is to call ->get() in the core after calling
>>> ->init().
>>
>> It would be easier to review if you add me to CC on the new APIs you
>> implement as well. Now I had to look up what the ->get() call did.
> 
> I know my track record hasn't been impressive on this subject but I am
> sure I am following this since sometime now :)
> 
> https://lkml.org/lkml/2013/8/14/285

Sorry, my bad, I actually had gotten it, it was just so too short to notice.

-- 
mvh
Hans-Christian Egtvedt

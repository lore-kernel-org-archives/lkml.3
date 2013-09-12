Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3ILWKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:10:48 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63855 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3ILWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:10:47 -0400
Message-ID: <52323BE4.5080100@gmail.com>
Date: Thu, 12 Sep 2013 15:10:44 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
References: <20130912133855.GA23780@gmail.com> <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com> <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com> <20130912184341.GA11400@ghostprotocols.net> <52321CE4.1080804@gmail.com> <20130912201855.GC32644@gmail.com> <20130912203831.GD11400@ghostprotocols.net> <20130912204618.GA3262@gmail.com> <52322D81.5090708@gmail.com> <20130912211846.GA7890@gmail.com>
In-Reply-To: <20130912211846.GA7890@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/13 2:18 PM, Ingo Molnar wrote:
>> kconf approach of course:
>>    https://lkml.org/lkml/2013/4/1/600
>> (minus the manual steps in that RFC).
>
> I'm not sure what the end stage is where you'd like to arrive, but I don't
> think that forcing a separate configuration pass is an improvement :-/

once I have a working config -- say one for a target (minimal build) and 
one for analysis (more but not all features -- eg., no gtk) I never see 
auto-probing again. At best some new feature (config) comes along and 
the config has to be updated again, but kconf only inquires about new 
features.

>
> By default a simple 'make' should build perf to the maximum extent
> possible, with no other input required from the user - with warnings
> displayed as package install suggestions.

By default there is no config. Autoprobing generates a first one or a 
user can specify a defconfig.

David

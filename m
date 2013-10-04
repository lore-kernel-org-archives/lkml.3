Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3JDREW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:04:22 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58323 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3JDREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:04:20 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <524EC658.90706@roeck-us.net>
References: <20131004010230.GI27287@sirena.org.uk>
	<524E50DB.3060707@roeck-us.net>
	<CAOesGMhc5WYRFcBVSHShg6h8hn4HueGZtGCFKkzfX4SQEe_5LQ@mail.gmail.com>
	<524EC658.90706@roeck-us.net>
Date: Fri, 4 Oct 2013 10:04:20 -0700
Message-ID: <CAOesGMj_DoC4iHsTMdbZ4sSOkbt-6nhaQgyFxtdvN96gXxyaxg@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 3
From: Olof Johansson <olof@lixom.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 6:44 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 10/03/2013 10:41 PM, Olof Johansson wrote:
>>
>> On Thu, Oct 3, 2013 at 10:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> On 10/03/2013 06:02 PM, Mark Brown wrote:
>>>>
>>>>
>>>> Hi all,
>>>>
>>>> Better late than never I've uploaded today's linux-next tree to the
>>>> master branch of the repository below:
>>>>
>>>>           git://gitorious.org/thierryreding/linux-next.git
>>>>
>>>> A next-20131003 tag is also provided for convenience.
>>>>
>>>> A few new conflicts today caused by the removal of the h8300
>>>> architecture which I didn't report for triviality.  Several new build
>>>> failures were found as a result of running allmodconfig tests between
>>>> merges all of which have been reported and I'm still carrying the i.MX
>>>> fix that Thierry has been carrying.
>>>>
>>>> Due to the length of time taken to run all the allmodconfigs I skipped
>>>> the defconfig tests; I know Olof has the ARM stuff covered in his
>>>> autobuilder.  I'm going to use allyesconfig tomorrow since that should
>>>> run faster so hopefully I can cover the ARM, i386 and x86_64 configs
>>>> again.
>>>>
>>>
>>> I could try to set up the buildbot farm I am using for -stable candidates
>>> to also test the -next tree. Would that help ?
>>
>>
>> ARM is pretty well-covered by my builds, I post results at:
>>
>> http://lists.linaro.org/mailman/listinfo/kernel-build-reports
>>
>
> Great summaries. Do you have a single builder, or several builders and
> collect the results ? Either case, any chance sharing the buildbot scripts ?

My buildbot scripts are some pretty ugly hacks that I don't
particularly feel like publishing to the world. I can send you a copy
though.

The builder is one single beefy machine that i have on loan. It
wouldn't be hard to make it distributed instead though; I've toyed
around with prototypes for that in the past.


-Olof

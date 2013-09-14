Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3INEe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:34:56 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:59793 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3INEey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <3040696.n8OU0605eG@vostro.rjw.lan>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<3040696.n8OU0605eG@vostro.rjw.lan>
Date: Sat, 14 Sep 2013 10:04:54 +0530
Message-ID: <CAKohpokn_FS1EcNdLg9jZJ=ChLPM1kjxtR5iFCxYyNpn1dDL7A@mail.gmail.com>
Subject: Re: [PATCH 000/228] CPUFreq: cleanup stuff for 3.13
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2013 05:08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, September 13, 2013 06:29:06 PM Viresh Kumar wrote:
>> This is my biggest patchset ever and it might not happen again in my entire
>> career. I hope I haven't screwed up here :)
>>
>> CPUFreq cleanup patches are ready to hit linux-next (I hope it doesn't turn out
>> into horror stories, where it broke all possible architectures where Linux runs
>> :))
>>
>> Most of these are build tested only, Also done by: Fengguang Wu's build bot.
>>
>> All of these were sent separately in smaller patchsets earlier and now merged
>> together as a single set. Some parts are reviewed by platform maintainers and
>> their Acks are included in the patches (Sorry if I missed any)..
>
> I believe I asked you to send this stuff in pieces.
>
> In any case, there's no way I'll apply this all at once and I'm not going to
> pull it all at once either.

Exactly for this reason I had following in my cover-letter:

"As suggested by Rafael earlier, he might not apply all at once and will give
people some chance to test sets one by one.. So, first set now, next one after
few days. So, I am marking different sets with patch numbers to make it easier
for Rafael.

- Patch 1->8: Generic cleanup of cpufreq core (First batch)
- Patch 9->54: Mostly about cpufreq_table_validate_and_show() helper
(First batch)
- Patch 55->89: New generic routines for cpufreq drivers (First/Second batch)
- Patch 90->126: About calling cpufreq_driver->get() from core
(First/Second batch)
- Patch 127->146: Generic init() routine (First/Second batch)
- Patch 147->180: Light weight ->target() routine (Third batch)
- Patch 181->211: Call notifiers from core instead of target()
(Third/Fourth batch)
- Patch 212->228: Generic get() (Fifth batch)
"

I kept them together because it looked like multiple patchsets have confused
people.. I have seen people reviewing first few sets and later on they haven't
bothered to review.. Probably they got confused..

And so it was required to keep them together, so that people get the complete
picture..

Sorry for the noise..

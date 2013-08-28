Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3H1Wno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:43:44 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47809 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3H1Wnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <521E7B8A.6060203@linaro.org>
References: <1375216733-6740-1-git-send-email-zoran.markovic@linaro.org>
	<3196266.rMZQj4Yosc@vostro.rjw.lan>
	<CAME+o4n8HqvGtAGX0wO+Zs_pdanKuhai6T3jg2V1Q4nWzxKk9A@mail.gmail.com>
	<1761440.cq52yMKNRv@vostro.rjw.lan>
	<521E7B8A.6060203@linaro.org>
Date: Wed, 28 Aug 2013 15:43:42 -0700
X-Google-Sender-Auth: npkeyRtD0AQCl_akmi2hlJwFCRY
Message-ID: <CAMbhsRSqSC1Ni4QsZ_0sTrvaW3_feXFyGawZbWc34wuhA2BNeg@mail.gmail.com>
Subject: Re: [RFC PATCHv3] drivers: power: Detect device suspend/resume lockup
 and log event in pstore.
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 3:36 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 08/28/2013 01:52 PM, Rafael J. Wysocki wrote:
>> On Wednesday, August 28, 2013 10:45:45 AM Zoran Markovic wrote:
>>> Hi Rafael,
>>>> It doesn't look too bad from a quick look, but there's a couple of things
>>>> I don't like in it still (relatively minor).
>>> If there are things you would like changed in this patch, please let
>>> me know. It would be nice to catch the 3.12 merge window.
>> Well, it's not in my queue to be honest.
>>
>> Is there any practical reason why it should go into the next release?
>
> I wouldn't say its critical for the next release, but I feel like this
> was the same response last cycle. Zoran's since investigated the various
> alternative approaches you've suggested, and continues to be interested
> in resolving your remaining objections.
>
> Its a useful feature the Android devs use, which could also help
> non-android developers debug suspend issues on their systems.
>
> If you really just feel its something best left out of tree, that's hard
> to argue against. Its just a debug tool and the android guys don't have
> an issue carrying their own tree, after all. But the cost of leaving it
> out is just the potential of others having to re-implement similar hacks
> on their own instead of collaborating on shared infrastructure.

And the benefit is that you are more likely to get bugreports that
have a stack trace of the offending suspend callback instead of "my
laptop doesn't suspend any more".

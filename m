Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3KUDYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:24:39 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:43026 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KUDYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:24:36 -0500
MIME-Version: 1.0
In-Reply-To: <7256587.cI3URDaS0R@vostro.rjw.lan>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
	<CAKohpo=+W9vTcfRcH=6t0Bbct2+GJYge60ZoQZwYuZ=An6UCtQ@mail.gmail.com>
	<CAKohpokQh_Awj2tzhFbqzv8u4zQ2WV0QZP0Sq1tqVQBYemW+gA@mail.gmail.com>
	<7256587.cI3URDaS0R@vostro.rjw.lan>
Date: Thu, 21 Nov 2013 08:54:36 +0530
Message-ID: <CAKohpokPcBufPm2UPzqiX974m=j-q6BaOSaSgSKNK8ob0QNs2w@mail.gmail.com>
Subject: Re: [PATCH V2 13/16] cpuidle: free all state kobjects from cpuidle_free_state_kobj()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2013 06:35, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, November 20, 2013 01:33:53 PM Viresh Kumar wrote:
>> Fixing Rafael's email id..
>>
>> On 20 November 2013 13:33, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> > On 3 October 2013 21:26, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> >> Loop for states is currently present on callers side and so is replicated at
>> >> several places. It would be better to move that inside cpuidle_free_state_kobj()
>> >> instead.
>> >>
>> >> This patch does it.
>> >>
>> >> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> >> ---
>> >>  drivers/cpuidle/sysfs.c | 23 ++++++++++++-----------
>> >>  1 file changed, 12 insertions(+), 11 deletions(-)
>> >
>> > Hi Rafael,
>> >
>> > You missed applying this one?
>
> I might.  Care to resend?

Sent..

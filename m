Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3BADyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:54:31 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:64271 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3BADy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:54:28 -0500
MIME-Version: 1.0
In-Reply-To: <1560132.gKXbKl82oR@vostro.rjw.lan>
References: <1359554017-28620-1-git-send-email-fabio.baltieri@linaro.org>
	<CAKohpomTNkEOrnyQWKJ8siajg67-fpe4EnYxiipgmN8STMSwAQ@mail.gmail.com>
	<20130131110613.GD30667@balto.lan>
	<1560132.gKXbKl82oR@vostro.rjw.lan>
Date: Fri, 1 Feb 2013 09:24:27 +0530
Message-ID: <CAKohpomcu4pZf8pwxCkW5RcGWbeEN3NTCpYWyzPGaUt6noB80w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: clean timer init and exit code
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 18:36, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 31, 2013 12:06:13 PM Fabio Baltieri wrote:
>> On Thu, Jan 31, 2013 at 04:23:06PM +0530, Viresh Kumar wrote:

>> > As discussed over IRC, you will fix following in few days:
>> > - Code redundancy within governors
>> > - Removing second_time: label and cdbs->enable field
>> > - Fixing params to timer init and exit to make them more efficient.
>>
>> That's the plan, I'd leave it up to Rafael to decide if further cleanup
>> patches should be included in 3.9 merge window or skip to the following
>> one... I understand that we are starting to be late on the -rc and I
>> also prefer to focus on fixup.
>
> The deadline for 3.9 merge window patches is about 2 days before 3.8-rc7
> (assuming that there will be -rc7) and by that time they need to be in
> linux-next.  Whatever doesn't make it will have to go after 3.9-rc1 or be
> postponed until the 3.10 merge window.

For everybody else, i have patched above in a different patchset.

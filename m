Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3F0PUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:20:47 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:55795 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3F0PUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:20:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomSNGn1wTzbCxpHN5fu2L6mJ1fnhvt2uLBWLgQE8fS6Rg@mail.gmail.com>
References: <51C87ADC.4070409@canonical.com>
	<CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
	<20130625161935.GA10208@jshin-Toonie>
	<CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
	<20130626142852.GA2326@jshin-Toonie>
	<CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
	<20130626175722.GA20226@jshin-Toonie>
	<CAKohpo=UTmpLmyQs5+xLNnCLMCeZHNQT3USjmK1NTaFJLNQg-Q@mail.gmail.com>
	<20130627145505.GA3076@jshin-Toonie>
	<CAKohpomSNGn1wTzbCxpHN5fu2L6mJ1fnhvt2uLBWLgQE8fS6Rg@mail.gmail.com>
Date: Thu, 27 Jun 2013 20:50:44 +0530
Message-ID: <CAKohpokQcL0iq6Oyt3zLGGTh4k_PoCpCzHFrgqWUmpUA3-2O3w@mail.gmail.com>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 June 2013 20:39, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 27 June 2013 20:25, Jacob Shin <jacob.shin@amd.com> wrote:
>> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
>> index 4b9bb5d..93eb5cb 100644
>> --- a/drivers/cpufreq/cpufreq_ondemand.c
>> +++ b/drivers/cpufreq/cpufreq_ondemand.c
>> @@ -47,6 +47,8 @@ static struct od_ops od_ops;
>>  static struct cpufreq_governor cpufreq_gov_ondemand;
>>  #endif
>>
>> +static unsigned int default_powersave_bias;
>
> Because you haven't replied to my earlier comment on this, I
> thought you agreed. But it looks you haven't read my first
> reply well.

BTW, your v1 is already applied and sent to Linus. So,
you need to send only fixup now.

But, you still need to answer why you need
default_powersave_bias? And if it is not a must then should be
removed.

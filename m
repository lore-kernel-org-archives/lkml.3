Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3FJNWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:22:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55766 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3FJNWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:22:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130610152027.3133d1ab@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1370502472-7249-6-git-send-email-l.majewski@samsung.com>
	<20130606155815.GB21272@pd.tnic>
	<20130610152027.3133d1ab@amdc308.digital.local>
Date: Mon, 10 Jun 2013 18:52:33 +0530
Message-ID: <CAKohponR3HtHMkvCCdzmAS+MMe0CawRYr-ome=SO80nLVaWbeQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpufreq:boost:Kconfig: Enable boost support at Kconfig
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2013 18:50, Lukasz Majewski <l.majewski@samsung.com> wrote:
> Hi,
>
>> On Thu, Jun 06, 2013 at 09:07:52AM +0200, Lukasz Majewski wrote:
>> > Enable/disable support for BOOST. New flag - CPU_FREQ_BOOST has been
>> > defined for that.
>>
>> What's the reason for this? Why would you want to not compile-in the
>> boosting code?
>
> I think that this flag could be removed and the "boost" could be
> compiled-in permanently.
>
> Viresh, what is your opinion?

Yes, Borislav is correct. I haven't actually reviewed these last patches as
I saw lots of issues with first one :)

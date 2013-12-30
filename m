Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3L3QlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:41:06 -0500
Received: from canardo.mork.no ([148.122.252.1]:47819 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab3L3QlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:41:04 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAKohpokW2FCN33VZOSUQ0xbgt6FgxtfQyPZintGL9URDHH8LCQ@mail.gmail.com>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org> <5562479.pVWRuDL0y6@vostro.rjw.lan> <CAKohponHBaGG1e5e+Wmg6rqMB-nbRx1e=F+u5AoaNb=mxfQL6A@mail.gmail.com> <CAKohpom9_-9bDJ9tWDHmm1inMporaHytAvmrgfPSs2koRqGzBw@mail.gmail.com> <CAKohpokW2FCN33VZOSUQ0xbgt6FgxtfQyPZintGL9URDHH8LCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
From: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Date: Mon, 30 Dec 2013 17:40:45 +0100
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <cb5a2c1a-7bca-494a-bbd0-704f93902ec9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, that's good. As you might have guessed by the lack of any response, I won't be able to test this in 2013.

Thanks for all the good work!


Bjørn 

Viresh Kumar <viresh.kumar@linaro.org> wrote:
>On 27 December 2013 15:27, Viresh Kumar <viresh.kumar@linaro.org>
>wrote:
>> I think there is nothing much different in this patch compared to
>what Bjorn
>> tested. So you can probably push that now and let him test linux-next
>later
>> once he is back?
>
>Just saw that you already pushed it. :)


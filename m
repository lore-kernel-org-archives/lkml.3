Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213Ab3FSDPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:15:22 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:37983 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3FSDPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:15:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpoktu5+h0YOCtoS6sq2UP2iU+z+nYjwB6rH7cRWDAOhRSA@mail.gmail.com>
References: <1371114118-19488-1-git-send-email-chenxg@marvell.com>
	<1912850.KuRKhn87Nf@vostro.rjw.lan>
	<CAFgnuDe1bUub92uE1H9Fc9U7AJCYL=WKdyDe2bg00yEr=kMEbQ@mail.gmail.com>
	<CAKohpoktu5+h0YOCtoS6sq2UP2iU+z+nYjwB6rH7cRWDAOhRSA@mail.gmail.com>
Date: Wed, 19 Jun 2013 08:45:19 +0530
Message-ID: <CAKohpokN_iJ5in0t3Mo68Tost0u2WT65PQtynQ7-wxGZr0LDQQ@mail.gmail.com>
Subject: Re: [PATCH v5] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Xiaoguang Chen <chenxg@marvell.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 08:43, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 19 June 2013 06:50, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
>> 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
>
>>>> 2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
>>>
>>> Can you please tell me what the above is supposed to mean?  Is it supposed to
>>> mean "the online of cpu3 is being run on cpu0" or something different?  If
>>> something different, then what?
>
> Please read all the questions carefully. You missed this one.
>
> Actually you should write: Current governor is userspace, now cpu0 hot-unplugs
> cpu3, it will **

Ahh I am mistaken, you are actually bringing cpu3 back to the system. Then you
must have mentioned earlier that cpu3 wasn't online.

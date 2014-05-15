Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaEOQiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:38:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37315 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaEOQh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:37:59 -0400
Message-ID: <5374ED61.8050804@infradead.org>
Date: Thu, 15 May 2014 09:37:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Mikulas Patocka <mpatocka@redhat.com>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Format of patches
References: <alpine.LRH.2.02.1405141012040.11670@file01.intranet.prod.int.rdu2.redhat.com>	<CAKohpo=h8cNbb2VbWzpDUPQDMK8QAs_sV=-SQyOaJWWFw4qKvA@mail.gmail.com>	<alpine.LRH.2.02.1405150614100.19101@file01.intranet.prod.int.rdu2.redhat.com>	<CAKohponwxi96buPx=vYgY1jZhSUanOZ2G7g2CjoapE=stzJcXw@mail.gmail.com>	<alpine.LRH.2.02.1405150843180.8791@file01.intranet.prod.int.rdu2.redhat.com> <CAKohpokGQSuts5rr4XeFb1dsykfNX-A--NXapkgJ2g0fUjVmQQ@mail.gmail.com>
In-Reply-To: <CAKohpokGQSuts5rr4XeFb1dsykfNX-A--NXapkgJ2g0fUjVmQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 07:00 AM, Viresh Kumar wrote:
> On 15 May 2014 18:15, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>>> ---
>>>
>>> Blurb here :)
>>
>> Sure - but if I want you to read "Blurb here :)" before reading the git
>> message, I need to place it at the top of the email, before the git
>> message.
> 
> You can't, git will pick it up :)

Right.  The patch description goes at the top of the email.
If you want to include text that should not be part of the patch
description, you can put it after the --- or you can put it into
an introductory email (like [PATCH 0/5]).

> And people are trained enough to read stuff at this place as it was
> present over the top of mail :)


-- 
~Randy

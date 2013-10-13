Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3JMS3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 14:29:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57697 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3JMS3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 14:29:15 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <525AE675.1010606@roeck-us.net>
Date: Sun, 13 Oct 2013 11:29:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.12-rc4 Fixes
References: <20131013180727.GN401@spo001.leaseweb.com> <525AE311.8060605@roeck-us.net> <20131013181933.GP401@spo001.leaseweb.com>
In-Reply-To: <20131013181933.GP401@spo001.leaseweb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2013 11:19 AM, Wim Van Sebroeck wrote:
> Hi Guenter,
>
>> Looks like the diffs don't match the description.
>> Are those possibly the diffs from your previous pull request ?
>
>>From a 3.6 pull request to be precisely :-( I use the old mail
> as template and apparently forgot to change the diff...
> The correct diff here below.
>

I use a template and script to generate my pull request e-mails to avoid
this kind of problem. This way worst that can happen is an unexpected
"rcX" in the headline ... unless the pull request itself is screwed up,
which I should hopefully notice before I send it out.

Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaFWDK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:10:29 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:35230 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaFWDK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <53A70420.4010005@roeck-us.net>
References: <53A66000.4010208@gmail.com>
	<CAF0htA7jReHGSL+K_rh9CMN_Wsyy=nL-TsN3T2L+FQUpAEXyrg@mail.gmail.com>
	<53A70420.4010005@roeck-us.net>
Date: Mon, 23 Jun 2014 11:10:27 +0800
Message-ID: <CAF0htA7oo9EO8E1JDXyuDZaDUkUAxASKuHtR63KE5WsGyDV+fQ@mail.gmail.com>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
From: Lennox Wu <lennox.wu@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it's the reason we still thank Chen's checking.
Arbitrary configurations except the default configure are not
guaranteed to pass compiling.
To discover combinations which doesn't make sense might weast Chen's time.

Best,
Lennox

2014-06-23 0:28 GMT+08:00 Guenter Roeck <linux@roeck-us.net>:
> On 06/22/2014 01:09 AM, Lennox Wu wrote:
>>
>> Hi Chen,
>> Do you find other modules except device modules cause issues of compiling?
>> The applications of Score are limited. Acutally, some errors never occur
>> in the limited applications, for example, the conbination consists of
>> Score and the timer of SuperH. I'm not sure we should handle this kind
>> of error.
>> If the rule is that we should make sure "all" modules can be compiled
>> with Score, we will do it.
>> However, we still thanks for your check.
>>
>
> Other architectures don't care about buildability of allmodconfig or
> allyesconfig
> (arm is a good [or maybe bad] example), so it is for sure not mandatory.
> On the other side, fixing such problems - especially when you have someone
> doing it for you - may prevent problems down the road, so while not
> mandatory
> I consider it a useful goal to achieve.
>
> If there is a driver which doesn't make sense to build at all, such as the
> SuperH
> timer driver mentioned above, it can always be excluded from building with
> Kconfig.
> If that causes opposition for some reason, you can still ignore that it
> fails
> to build.
>
> Guenter
>

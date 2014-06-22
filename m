Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaFVQ22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 12:28:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62253 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaFVQ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 12:28:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A70420.4010005@roeck-us.net>
Date: Sun, 22 Jun 2014 09:28:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>
CC: Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A66000.4010208@gmail.com> <CAF0htA7jReHGSL+K_rh9CMN_Wsyy=nL-TsN3T2L+FQUpAEXyrg@mail.gmail.com>
In-Reply-To: <CAF0htA7jReHGSL+K_rh9CMN_Wsyy=nL-TsN3T2L+FQUpAEXyrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2014 01:09 AM, Lennox Wu wrote:
> Hi Chen,
> Do you find other modules except device modules cause issues of compiling?
> The applications of Score are limited. Acutally, some errors never occur
> in the limited applications, for example, the conbination consists of
> Score and the timer of SuperH. I'm not sure we should handle this kind
> of error.
> If the rule is that we should make sure "all" modules can be compiled
> with Score, we will do it.
> However, we still thanks for your check.
>

Other architectures don't care about buildability of allmodconfig or allyesconfig
(arm is a good [or maybe bad] example), so it is for sure not mandatory.
On the other side, fixing such problems - especially when you have someone
doing it for you - may prevent problems down the road, so while not mandatory
I consider it a useful goal to achieve.

If there is a driver which doesn't make sense to build at all, such as the SuperH
timer driver mentioned above, it can always be excluded from building with Kconfig.
If that causes opposition for some reason, you can still ignore that it fails
to build.

Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaFWEpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 00:45:09 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39274 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaFWEpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 00:45:05 -0400
Message-ID: <53A7B0C9.6050201@gmail.com>
Date: Mon, 23 Jun 2014 12:44:57 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>, Guenter Roeck <linux@roeck-us.net>
CC: Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A66000.4010208@gmail.com>	<CAF0htA7jReHGSL+K_rh9CMN_Wsyy=nL-TsN3T2L+FQUpAEXyrg@mail.gmail.com>	<53A70420.4010005@roeck-us.net> <CAF0htA7oo9EO8E1JDXyuDZaDUkUAxASKuHtR63KE5WsGyDV+fQ@mail.gmail.com>
In-Reply-To: <CAF0htA7oo9EO8E1JDXyuDZaDUkUAxASKuHtR63KE5WsGyDV+fQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 11:10 AM, Lennox Wu wrote:
> Yes, it's the reason we still thank Chen's checking.
> Arbitrary configurations except the default configure are not
> guaranteed to pass compiling.
> To discover combinations which doesn't make sense might weast Chen's time.
> 

It does not waste my time resource (at least, I perform open source
patches during my free time). And cross-compile all architectures with
allmodconfig can:

 - let architectures a little better than before.

 - let other modules within kernel a little better than before.

 - may let open source cross-compiler a little better than before.

And for me, I also can learn much during perform these things.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

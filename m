Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaFYWJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:09:59 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50101 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaFYWJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:09:58 -0400
Message-ID: <53AB48AB.3000808@gmail.com>
Date: Thu, 26 Jun 2014 06:09:47 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>
CC: David Rientjes <rientjes@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A9783C.7050206@gmail.com> <53A98F6F.4080503@roeck-us.net> <alpine.DEB.2.02.1406241549430.29176@chino.kir.corp.google.com> <53AA0553.6020909@roeck-us.net> <alpine.DEB.2.02.1406241639310.22030@chino.kir.corp.google.com> <53AA251D.9070100@gmail.com> <CAF0htA5VjUy52OKod6kxA43kjyZPj+CHcSrFmhNEn-bD0GvtgA@mail.gmail.com>
In-Reply-To: <CAF0htA5VjUy52OKod6kxA43kjyZPj+CHcSrFmhNEn-bD0GvtgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 11:16 PM, Lennox Wu wrote:
> These marcos are listed in advance.
> Indeed, they have not been used, and the functions use them have not
> be released.

UAPI is the main interface for contribution to outside, that is our
main goal, and has the highest priority.

After new contents are added into UAPI, it is very hard to remove them
again: it is protocol, can only be complement, but can not be changed
(or will be a 'cheat').


> I would like to keep the status even if the configure should not be used.
> However, if guys think it is dirty, maybe we can remove or comment them first.
> 

So, for me, if we find the new contents in UAPI may have negative effect to
outside, we need stop it firstly (at least, not let it merged into main line).


If no any additional reply for it within this week, I shall send patch
v3 for it (simply remove them).

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed

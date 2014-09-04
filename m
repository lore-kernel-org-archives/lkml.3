Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaIDPft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:35:49 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:45359 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaIDPfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:35:46 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org.openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] kcmp: Fix standard comparison bug
Organization: D03
References: <1409827206-4199-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140904132912.GL16395@moon>
X-Hashcash: 1:20:140904:stable@vger.kernel.org::fsiXAi+2hypDA7Rf:00000000000000000000000000000000000000005OH
X-Hashcash: 1:20:140904:ebiederm@xmission.com::wfoLzpiQALZtbK64:00000000000000000000000000000000000000001Aaj
X-Hashcash: 1:20:140904:gorcunov@gmail.com::Ig3j0DOclmZZB+zi:00000000000000000000000000000000000000000001gdY
X-Hashcash: 1:20:140904:akpm@linux-foundation.org.openvz.org::73fKkPzicVZAEcKi:00000000000000000000000001hi2
X-Hashcash: 1:20:140904:hpa@zytor.com::epiC6Kb7o1ilhzXr:00002YCm
X-Hashcash: 1:20:140904:xemul@parallels.com::XSa8aW/Pgsxrvw7r:00000000000000000000000000000000000000000049UB
X-Hashcash: 1:20:140904:linux-kernel@vger.kernel.org::dqcFvHRrgPCXtGEY:0000000000000000000000000000000007HCf
Date: Thu, 04 Sep 2014 17:35:43 +0200
In-Reply-To: <20140904132912.GL16395@moon> (Cyrill Gorcunov's message of "Thu,
	4 Sep 2014 17:29:12 +0400")
Message-ID: <87sik7tn3k.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04 2014, Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Thu, Sep 04, 2014 at 12:40:06PM +0200, Rasmus Villemoes wrote:
>> 
>> Note that it makes absolutely no difference that a transmogrying
                                                       ^^^^
                                                    transmogrifying

> It's more than that, I looked into disassembly code and
> found that compiler overoptimize obfuscation, instead of doing
> ^ and * sequently it substracts xor production of both operands
> first and only then multiplies the result.

...which it seems to be perfectly entitled to; xz - yz == (x-y)z holds
in any ring. 

Anyway, I'll stop beating the dead horse.

Rasmus

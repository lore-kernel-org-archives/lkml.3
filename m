Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3AZADy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:03:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52865 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3AZADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:03:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH v3 21/44] metag: Time keeping
Date: Sat, 26 Jan 2013 00:03:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <1357831872-29451-22-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1357831872-29451-22-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301260003.43854.arnd@arndb.de>
X-Provags-ID: V02:K0:7mrjDQGMdPAvR/3kOC4D4lTwamNMAgLHPHeZRHMzDyR
 3eDvufLVz7szaxtYtg+u+5bAQlO62knpD+AkzNSSM41kz9a+Yh
 pF+O+Xb3pnFqkH+ungicOKomPfllSn+cVufhjaVZP4v88pg4qO
 uBvjwOFkJKDtsFdye+HvYiSV0crvmBsYpTUWsFAqTWhZx+/nqY
 mIYDupZTgDhB7EEnakGcfWF85MvRAdVnk5tFviaT/ZByHq3ZNP
 PzJgIgtSS1vsYQnAsVvTPgg+TU0ugWz3D4HEom2iqEGgS//d7J
 N6c+4UKVoCEf81soOYB4vQ6c2Ygn02hnnmhgO5jR+jb+9aWmKr
 E2/RikDfb9nT9uR4NUm0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013, James Hogan wrote:
> Add time keeping code for metag. Meta hardware threads have 2 timers.
> The background timer (TXTIMER) is used as a free-running time base, and
> the interrupt timer (TXTIMERI) is used for the timer interrupt. Both
> counters traditionally count at approximately 1MHz.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  arch/metag/include/asm/clock.h     |   51 +++++++++++
>  arch/metag/include/asm/delay.h     |   29 +++++++
>  arch/metag/include/asm/mach/arch.h |    4 +
>  arch/metag/kernel/clock.c          |   53 ++++++++++++
>  arch/metag/kernel/time.c           |  163 ++++++++++++++++++++++++++++++++++++

We are actually moving clocksource drivers to drivers/clocksource
now, maybe you can move this one too.

	Arnd

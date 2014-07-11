Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaGLMQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:16:10 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58541 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaGLMQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:16:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 33/55] powerpc: cell: Use ktime_get_ns()
Date: Fri, 11 Jul 2014 19:02:28 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <20140711133623.530368377@linutronix.de> <20140711133708.084581358@linutronix.de>
In-Reply-To: <20140711133708.084581358@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407111902.28730.arnd@arndb.de>
X-Provags-ID: V02:K0:phufua+2FRjfs5PuPZk4UWm6pr90Ej1i/pUEE2e6dM1
 wjEXSRV1gYPISXTIyf6KNiXEZNsB66wWgy73yCTkNSCtgYk8Ti
 Cr61VOFuX8J3KT0zMQuOFL7ResKV/owN9L2E/5PmRSOGlOMt1J
 hxJja+txX1vlHXETCXOnQf4mhdSbMM3hkoVkZMq9k28FxnMvYA
 nIw0hYYBJBOnAnYOpbuF0ew0/bkB9tuB4u412WpidzWoHplLF5
 xNTzhu/REwh1lnjUOolrlbmbsfHRnqk3mGCHXuRPrtuhGLmtMU
 hShQY2R+53/J4Hw12zYCQngpik2uyOOdtZ78BfC1kytCaP9xP0
 5vlARiPkAgtM4ZFbtpmI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2014, Thomas Gleixner wrote:
> Replace the ever recurring:
>         ts = ktime_get_ts();
>         ns = timespec_to_ns(&ts);
> with
>         ns = ktime_get_ns();
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

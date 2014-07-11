Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaGLMPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:15:51 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55130 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaGLMPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:15:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 47/55] hangcheck-timer: Use ktime_get_raw_ns()
Date: Fri, 11 Jul 2014 19:03:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <20140711133623.530368377@linutronix.de> <20140711133709.245458528@linutronix.de>
In-Reply-To: <20140711133709.245458528@linutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407111903.58106.arnd@arndb.de>
X-Provags-ID: V02:K0:lljibJJKdJ0fyR0Zn/CiUNt+UWpYzSKg3Dw2IekipYp
 ZN25e1uO9MRk5Sq19UZZGc1TgznwgmFuQabB8AIG7ChXszWQt7
 UofJgnHNhGaWaMiF/vumOus1jmLVMKyvIoDYOKAUlt+JiA2zhW
 urTjCOWTUbuhW+4iN9OkG2Ol5HDDoASXexyCya+dBWhMzCrdQ5
 3Q6bw6JUwM8q72nf93M6Ruto0xKoc3sIFWpq7Kgpody19QcelQ
 /fUctOHU8ITUSXFpi4S3L1fgMIk2Q2x8EbQX7eEz2ltbPREdof
 njDYaekXHd6gzWn90d+Iz9JSzdLVhD4rohg34RtshHQ1VofM7z
 O9c0qi/zPPHLptaNnBS4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2014, Thomas Gleixner wrote:
> Use the nanoseconds based interface instead of converting timespecs.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

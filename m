Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaIYKdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:33:12 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59581 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaIYKdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:33:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, chris@zankel.net, cmetcalf@tilera.com,
        davem@davemloft.net, deller@gmx.de, dhowells@redhat.com,
        geert@linux-m68k.org, heiko.carstens@de.ibm.com, hpa@zytor.com,
        jcmvbkbc@gmail.com, jesper.nilsson@axis.com, mingo@redhat.com,
        monstr@monstr.eu, paulmck@linux.vnet.ibm.com, rdunlap@infradead.org,
        sam@ravnborg.org, schwidefsky@de.ibm.com, starvik@axis.com,
        takata@linux-m32r.org, tglx@linutronix.de, tony.luck@intel.com,
        daniel.thompson@linaro.org, broonie@linaro.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v3 01/17] asm-generic: io: implement relaxed accessor macros as conditional wrappers
Date: Thu, 25 Sep 2014 12:32 +0200
Message-ID: <4501051.vdxhyhkTWv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411579056-16966-2-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <1411579056-16966-2-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:chMdHxrPhPaZztYCkE63CMy0+L//44NBwHNwJzhhusy
 YhI7I8DVioZ2cjw8XgOdNgBD7Af+CfXN97k2F2rzergzHd+Q29
 z3N/2ntEMqZiBSnjKyPaYedk0W3RclEFVE+NfmtGDw3+BPwlge
 Zn800q29mZ0Y1gwL2/ZaVjmKkVKsHWMY2RSO6ROJQHSs9nBJF1
 yLqAW+G4G3+EOyS21nbwKnXoyivGf6yHSgjCPAJoXJvZAOOiLe
 wZKthY7j6Jnggw/FO+RopKOpjeCwWoow7cNh5J686k8VKlMghh
 OPf4cMVH4jQ0u+AEW8mfBbnfw8d57PycGLo/rWOV+uuiaFd+0T
 icBnX0ouUaUgtUHkhlqo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 18:17:20 Will Deacon wrote:
> {read,write}{b,w,l,q}_relaxed are implemented by some architectures in
> order to permit memory-mapped I/O accesses with weaker barrier semantics
> than the non-relaxed variants.
> 
> This patch adds wrappers to asm-generic so that drivers can rely on the
> relaxed accessors being available, even if they don't always provide
> weaker ordering guarantees. Since some architectures both include
> asm-generic/io.h and define some relaxed accessors, the definitions here
> are conditional for the time being.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  include/asm-generic/io.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

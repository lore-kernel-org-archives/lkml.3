Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbaIZVh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:37:57 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54682 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbaIZVhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:37:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
Date: Fri, 26 Sep 2014 23:36:13 +0200
Message-ID: <3359318.XmOCYLZHTV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140926134608.GT5182@n2100.arm.linux.org.uk>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <9197976.uQdLmtvIl1@wuerfel> <20140926134608.GT5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bM3Q1b8/aU2pCNY2r/Lg3Tc9zXJw3fgugz4QWaVIaev
 DFHp5aHG8GZ6z3Nsa5tWnVnJbrLv36JOwaFzjVtUGJY/nf6UKU
 RvYiQX9gwRUQFJGlLN6b89a1HpuFIigp9Gmubt2RPqRXQV+5AL
 B94/RzNj5YUhchZ4MYyycOjgbbemmou0JV2PA/SN9qvm/+LOBO
 me650cgTc3oC+qIxoONUiyIe5RtBEijKqaOQJTHqdTZWIAelW2
 XKAo6v7zalkDtqjBo7ThsfdPWySnAxLXd012h+jlFEM9m8IcI1
 0qLUde78VpdH1Q5vnpFkI6wjil7wTBEBar204mq5b4s6PuBgGK
 7p/3L3G3eLgBZ/fuWFc8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 14:46:08 Russell King - ARM Linux wrote:
> 
> Obviously, this does nothing for the:
> 
> include/asm-generic/io.h:804:29: error: redefinition of 'virt_to_bus'
> include/asm-generic/io.h:809:21: error: redefinition of 'bus_to_virt'
> 
> errors which are also reported in Olof's build system.
> 
> Given how close we are to the merge window, I'd suggest this stuff gets
> reverted so that it can have a better period of testing, rather than
> stuffing it into -next at such a critical time.

Right, I've fixed these all up locally, but then found new warnings on
allmodconfig builds that I haven't been able to track down yet.

I've dropped everything from the asm-generic tree now, so we can get
a clean linux-next tree.

	Arnd

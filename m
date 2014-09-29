Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaI2Jwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:52:40 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58250 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaI2Jwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:52:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
Date: Mon, 29 Sep 2014 11:50:13 +0200
Message-ID: <2012641.4eaGXZM5vo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140929082323.GE12506@ulmo>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <3359318.XmOCYLZHTV@wuerfel> <20140929082323.GE12506@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kUjXB5Oe6XwdKkL2ocHAUTl2lzV0iriOitrWgfoHS3y
 Uxc0h2QUrZalaFj2tGKj4eYV0Z0rZXZ7vdYlTk2dDeE6Fma1Bd
 4YUh/u9YgcsoYLmsRuDbIujBTaMpr84U2TNOGPO3o7cnR3XUav
 B98jIrHw9iw0VZ+W7gH4SseNF5fGYGiwp7RXC5hqYW/DdbWii/
 HgSC+t3uKzhwsputSdaBGMa7M7XpSIpMzCyJndbVBb2idDUSke
 of3+8bGNE3Nm7QJXQgZRV9LOnY+fXUn7qpZkxAdifHTh47Valg
 21v2+NAPIMxMyZYGBJCivXH2E51tpZqmgdSiCvGGdB/lz+7va0
 66IM5aj3ptvxCxxqAIeA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 10:23:25 Thierry Reding wrote:
> 
> How about if I keep iterating this series? It seems like most failures
> can be reproduced by doing ARM defconfig and allmodconfig builds, so
> I'll do those and fix up any issues I find. Hopefully I can squash all
> these before 3.18-rc1, then we can take it into linux-next early for
> 3.19? In the meantime perhaps I can work with Olof to get a branch with
> these patches tested on his builder? And perhaps on the 0-day builder in
> addition?

Yes, definitely!

Note that I saw a lot of problems only in randconfig build tests but
not in any of the default configurations. I'll send you the fixup patch
soon so you can integrate that in your series.

	Arnd

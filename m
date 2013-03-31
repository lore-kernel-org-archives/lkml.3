Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3CaBdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 21:33:07 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:58422 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab3CaBdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 21:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <2835305.o7Hvg1cesG@vostro.rjw.lan>
References: <03ca6f17860d290cfc67e51969062612f0ab26ab.1364643234.git.viresh.kumar@linaro.org>
	<2835305.o7Hvg1cesG@vostro.rjw.lan>
Date: Sun, 31 Mar 2013 07:03:04 +0530
Message-ID: <CAKohpo=vorTDONBR2czcZpP64sCfv1Qa-u8zGkHys9miwQrURw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Raname index as data in cpufreq_frequency_table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, Sekhar Nori <nsekhar@ti.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2013 03:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Sorry, I won't apply this.  It changes too much stuff at a time and I'm not
> really sure if the change being made is necessary.

Hmm.. I thought it is important  as it puts the real meaning of "index" in the
code. It is big as it fixes all the users of cpufreq_frequency_table, if i don't
do it this way it will break git bisect.

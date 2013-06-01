Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3FAJDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:03:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3FAJC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:02:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 07/15] cpufreq: spear needs cpufreq table
Date: Sat, 01 Jun 2013 11:03:01 +0200
Message-ID: <2104181.OHBofkq3lH@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAKohpomzoGsOoQ__fd0V651bjWt2=JTC10wGSQzX2yyTcWZmvA@mail.gmail.com>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de> <1370038972-2318779-8-git-send-email-arnd@arndb.de> <CAKohpomzoGsOoQ__fd0V651bjWt2=JTC10wGSQzX2yyTcWZmvA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Gnva7nGfcMTHVpo4DCNhlYwVojWFDOGQaZh23kJzeMT
 t7aEjoVT/MUMIGs+LU7thGkXTGJfdphARo7l4+gwv1g9D+yEQw
 EGCMovfLmvxYbDdHdsGKtM+oQUUsnAHyipjTycbNbCdRAv+Rpl
 w43/xmUOvouBFpXJoAaMeBxobJfOfCvhY/5kyayjGP5F1mZ8cq
 3ZL593KN1oeH6U/3f1HUfOts+15DdOkfnQlKmi51vELI74OOsO
 5qrRZX0g/83Ud8b664xU00vbipP28dHKnv69/jUoRntIN8JUcs
 5t8iD+SBoTWWxxcg4B4thEHYh89ZvtsHm94f/+3oqrI41Oxees
 FHk1lNBne4tSR5D+kfmA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 June 2013 07:28:01 Viresh Kumar wrote:
> On 1 June 2013 03:52, Arnd Bergmann <arnd@arndb.de> wrote:
> > Like a lot of the other cpufreq drivers, this one needs to
> > select CONFIG_CPU_FREQ_TABLE to avoid a build error like
> >
> > drivers/built-in.o: In function `spear_cpufreq_exit':
> > spear-cpufreq.c:198: undefined reference to `cpufreq_frequency_table_put_attr'
> > drivers/built-in.o: In function `spear_cpufreq_verify':
> > spear-cpufreq.c:35: undefined reference to `cpufreq_frequency_table_verify'
> > drivers/built-in.o: In function `spear_cpufreq_init':
> > spear-cpufreq.c:181: undefined reference to `cpufreq_frequency_table_cpuinfo'
> > spear-cpufreq.c:187: undefined reference to `cpufreq_frequency_table_get_attr'
> > drivers/built-in.o: In function `spear_cpufreq_target':
> > spear-cpufreq.c:120: undefined reference to `cpufreq_frequency_table_target'
> > drivers/built-in.o:(.data+0x5e63c): undefined reference to `cpufreq_freq_attr_scaling_available_freqs'
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Cc: cpufreq@vger.kernel.org
> > Cc: linux-pm@vger.kernel.org
> > ---
> >  drivers/cpufreq/Kconfig.arm | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> BTW, you want me to apply this one or take it through arm-soc tree?

As I said in the introductory mail, I would prefer it if you
can pick it up. Thanks!

	Arnd

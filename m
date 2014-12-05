Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbaLEB6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:58:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51114 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933009AbaLEB6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:58:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kamil Debski <k.debski@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Fri, 05 Dec 2014 03:19:48 +0100
Message-ID: <4616754.qb41AxUOEJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141204160840.7d021bf1@recife.lan>
References: <4139875.fkJ48z9AaU@vostro.rjw.lan> <20141204160840.7d021bf1@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 04, 2014 04:08:40 PM Mauro Carvalho Chehab wrote:
> Em Wed, 03 Dec 2014 03:13:55 +0100
> "Rafael J. Wysocki" <rjw@rjwysocki.net> escreveu:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> > depending on CONFIG_PM_RUNTIME may now be changed to depend on
> > CONFIG_PM.
> > 
> > The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> > replaced with CONFIG_PM too.
> > 
> > Make these changes everywhere under drivers/media/.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Feel free to apply it via your tree.

Thanks!

> PS.: I won't doubt that you would find some extra checks for
> PM_RUNTIME on other places at media, as I remember I merged some
> things like that recently - I think they are there for 3.19, but
> it needs to be double-checked.

That's fine.  There is at least one case when I need to wait for
other trees to get merged due to files being moved around, so I'll
do a second round during the merge window anyway.

Kind regards,
Rafael


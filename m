Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbbA1UMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:12:25 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:53896 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbbA1UMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:12:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pavel Machek <pavel@ucw.cz>, Rob Herring <robherring2@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Date: Wed, 28 Jan 2015 20:27:07 +0100
Message-ID: <1511378.TNkQ0peTI1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150128180322.GA16868@amd>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com> <20150128180322.GA16868@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:1Gkg/gLkOo1vVgTEwkLl34TrOP5wrNqx1b1Woi81j49YSyqED9B
 ScyAUogv2n1ptW5Osp6CSgYYWLbtpGuKbHezw6oHBaA0BZesfGcrEV9bu1OHb4cjeHbm7oF
 w0GALd0kSremrgxIxdRgkhVBOatKsN4maRBB0UJsR3gxG4fFve6apYolffJh9AmJeOjn1yn
 2jC0V5xRKEBTYSxqcwHLg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 19:03:22 Pavel Machek wrote:
> > /proc/device-tree. I hope to be retired when that happens...
> 
> Huh. Who thought putting device-tree into /proc was good idea? That
> should have gone to /sys, as it is not process related...
> 

I think /proc/device-tree predates sysfs by about six years. These
days, it is a symlink to /sys/firmware/devicetree/base.

	Arnd

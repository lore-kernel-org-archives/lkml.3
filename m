Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab3ANStG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:49:06 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40635 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab3ANStC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:49:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Mon, 14 Jan 2013 19:54:53 +0100
Message-ID: <1814895.KpbBrTDE8x@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+icZUX7O6bAzSL_ysSum2psQC0M3K2EE5QUYL68F62vSsKfrA@mail.gmail.com>
References: <20130114110311.a399f92e5e4ec730b380eaf4@canb.auug.org.au> <CA+icZUX7O6bAzSL_ysSum2psQC0M3K2EE5QUYL68F62vSsKfrA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 02:22:20 PM Sedat Dilek wrote:
> On Mon, Jan 14, 2013 at 1:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Rafael,
> >
> > After merging the pm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > In file included from init/main.c:25:0:
> > include/linux/acpi.h:549:46: error: unknown type name 'acpi_handle'
> > include/linux/acpi.h:551:49: error: unknown type name 'acpi_handle'
> >
> > and many more.
> >
> > Caused by commit c9b147cd9648 ("ACPI / PM: Rework the handling of devices
> > depending on power resources").  Please check with and without CONFIG
> > options that affect patches ...
> >
> > I have used the pm tree from next-20130111 for today.
> 
> [ Please also CC linux-next ML ! ]
> 
> [ QUOTE ]
> Thanks for the report and sorry for the breakage.  Should be fixed now.
> 
> Rafael
> [ /QUOTE ]
> 
> What was the cause for this?
> 
> Did you refresh "ACPI / PM: Rework the handling of devices depending
> on power resources" [1]?

I did.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3HFWTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:19:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58465 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab3HFWTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:19:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] ACPI: acpi_bind_one()/acpi_unbind_one() cleanups
Date: Wed, 07 Aug 2013 00:29:49 +0200
Message-ID: <7035316.4VkUaO4qFC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375823736.10300.196.camel@misato.fc.hp.com>
References: <3015032.qfOqgEVZKP@vostro.rjw.lan> <1375823736.10300.196.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 03:15:36 PM Toshi Kani wrote:
> On Tue, 2013-08-06 at 02:22 +0200, Rafael J. Wysocki wrote:
> > Hi All,
> > 
> > The following 5 patches clean up a little mess in acpi_bind_one() and
> > acpi_unbind_one().  They are on top of current linux-next plus the patch
> > at https://patchwork.kernel.org/patch/2839101/ .
> > 
> > [1/5] Move duplicated code from acpi_bind_one()/acpi_unbind_one() to a separate
> >       function.
> 
> I think the name of acpi_bind_physnode_name() is a bit confusing as if
> it would make some persistent binding.  So, I'd suggest to rename it to
> acpi_set_physnode_name().

In fact, the plan was to make it mean "physical node name for acpi_bind", but
the execution was somewhat sloppy. ;-)

I think I'll call it acpi_physnode_link_name(), that should be clear enough.

> > [2/5] Create symlinks in acpi_bind_one() under physical_node_lock.
> > [3/5] Clean up inconsistent use of whitespace in acpi_bind_one()/acpi_unbind_one().
> > [4/5] Use list_for_each_entry() to walk the list in acpi_unbind_one().
> > [5/5] Clean up the error code path in acpi_unbind_one().
> 
> All changes look good.  For the series:
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks!

Rafael


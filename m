Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3HFWwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:52:32 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:36848 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab3HFWwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:52:30 -0400
Message-ID: <1375829481.10300.197.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/5] ACPI: acpi_bind_one()/acpi_unbind_one() cleanups
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Aug 2013 16:51:21 -0600
In-Reply-To: <7035316.4VkUaO4qFC@vostro.rjw.lan>
References: <3015032.qfOqgEVZKP@vostro.rjw.lan>
	 <1375823736.10300.196.camel@misato.fc.hp.com>
	 <7035316.4VkUaO4qFC@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 00:29 +0200, Rafael J. Wysocki wrote:
> On Tuesday, August 06, 2013 03:15:36 PM Toshi Kani wrote:
> > On Tue, 2013-08-06 at 02:22 +0200, Rafael J. Wysocki wrote:
> > > Hi All,
> > > 
> > > The following 5 patches clean up a little mess in acpi_bind_one() and
> > > acpi_unbind_one().  They are on top of current linux-next plus the patch
> > > at https://patchwork.kernel.org/patch/2839101/ .
> > > 
> > > [1/5] Move duplicated code from acpi_bind_one()/acpi_unbind_one() to a separate
> > >       function.
> > 
> > I think the name of acpi_bind_physnode_name() is a bit confusing as if
> > it would make some persistent binding.  So, I'd suggest to rename it to
> > acpi_set_physnode_name().
> 
> In fact, the plan was to make it mean "physical node name for acpi_bind", but
> the execution was somewhat sloppy. ;-)
> 
> I think I'll call it acpi_physnode_link_name(), that should be clear enough.

Sounds good to me.

Thanks,
-Toshi


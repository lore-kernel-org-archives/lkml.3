Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3HFVQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:16:45 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:2677 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab3HFVQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:16:44 -0400
Message-ID: <1375823736.10300.196.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/5] ACPI: acpi_bind_one()/acpi_unbind_one() cleanups
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 06 Aug 2013 15:15:36 -0600
In-Reply-To: <3015032.qfOqgEVZKP@vostro.rjw.lan>
References: <3015032.qfOqgEVZKP@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 02:22 +0200, Rafael J. Wysocki wrote:
> Hi All,
> 
> The following 5 patches clean up a little mess in acpi_bind_one() and
> acpi_unbind_one().  They are on top of current linux-next plus the patch
> at https://patchwork.kernel.org/patch/2839101/ .
> 
> [1/5] Move duplicated code from acpi_bind_one()/acpi_unbind_one() to a separate
>       function.

I think the name of acpi_bind_physnode_name() is a bit confusing as if
it would make some persistent binding.  So, I'd suggest to rename it to
acpi_set_physnode_name().

> [2/5] Create symlinks in acpi_bind_one() under physical_node_lock.
> [3/5] Clean up inconsistent use of whitespace in acpi_bind_one()/acpi_unbind_one().
> [4/5] Use list_for_each_entry() to walk the list in acpi_unbind_one().
> [5/5] Clean up the error code path in acpi_unbind_one().

All changes look good.  For the series:

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


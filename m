Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab3ANWVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:21:42 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38124 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab3ANWVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:21:40 -0500
MIME-Version: 1.0
In-Reply-To: <3885603.ydrrB7OEKf@vostro.rjw.lan>
References: <3885603.ydrrB7OEKf@vostro.rjw.lan>
Date: Mon, 14 Jan 2013 14:21:38 -0800
X-Google-Sender-Auth: Ti9XcPhewmgnfN1n1bu8_xXy7HE
Message-ID: <CAE9FiQUbQVdxDxD68ktZhFuJYs861-aFEXjTOgee1ueEous2eQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] ACPI: Rework acpi_bus_trim()
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 1:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> The next three patches actually rework acpi_bus_trim() in three steps:
>
> [3/5] Drop the second argument of acpi_bus_trim() (all callers pass 1 in there
>       anyway.
> [4/5] Reimplement acpi_bus_trim() using acpi_walk_namespace().
> [3/5] Make acpi_bus_trim() carry out two passes as described above.
>
> I'm aware of the fact that this will conflict with the patches that Yinghai
> posted a few days ago, but in my opinion the changes here are prerequisite for
> the Yinghai's patchset.

Sure, I will drop my change to acpi_bus_trim() and update one
reference accordingly.

Acked-by: for those 5 patches.

So you will put those patches in acpi-scan, and Bjorn will pull that
again to pci tree?

Thanks

Yinghai

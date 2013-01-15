Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3AOAi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:38:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56536 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3AOAiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:38:54 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50F4A4FC.3070904@jp.fujitsu.com>
Date: Tue, 15 Jan 2013 09:38:20 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: Re: [PATCH 0/5] ACPI: Rework acpi_bus_trim()
References: <3885603.ydrrB7OEKf@vostro.rjw.lan>
In-Reply-To: <3885603.ydrrB7OEKf@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/01/15 6:33, Rafael J. Wysocki wrote:
> Hi All,
>
> This series of patches changes the way acpi_bus_trim() works so that,
> eventually, it walks the namespace twice detaching (ACPI) drivers from
> device nodes being removed in the first pass and removing the device
> nodes in the second pass.
>
> The first two patches are just cleanups removing unused stuff:
>

> [1/5] Remove the ops field from struct acpi_device (unrelated to the rest).
> [2/5] Drop the second argument of acpi_device_unregister().
>
> The next three patches actually rework acpi_bus_trim() in three steps:
>
> [3/5] Drop the second argument of acpi_bus_trim() (all callers pass 1 in there
>        anyway.
> [4/5] Reimplement acpi_bus_trim() using acpi_walk_namespace().
> [3/5] Make acpi_bus_trim() carry out two passes as described above.

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

>
> I'm aware of the fact that this will conflict with the patches that Yinghai
> posted a few days ago, but in my opinion the changes here are prerequisite for
> the Yinghai's patchset.
>
> Thanks,
> Rafael
>
>



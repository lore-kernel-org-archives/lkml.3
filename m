Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaA1WFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:05:55 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:19684 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaA1WFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:05:52 -0500
Message-ID: <1390946378.1792.514.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / scan: Clear match_driver flag in acpi_bus_trim()
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 28 Jan 2014 14:59:38 -0700
In-Reply-To: <1737561.u7lWGR6b7C@vostro.rjw.lan>
References: <1737561.u7lWGR6b7C@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 01:16 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Drivers should not bind to struct acpi_device objects that
> acpi_bus_trim() has been called for, so make that function
> clear flags.match_driver for those objects.
> 
> If that is not done, an ACPI driver may theoretically try to operate
> a device that is not physically present.
> 
> Fixes: 202317a573b2 (ACPI / scan: Add acpi_device objects for all device nodes in the namespace)
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi




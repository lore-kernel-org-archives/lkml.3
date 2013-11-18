Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3KRSH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:07:58 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:48553 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3KRSHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:07:49 -0500
Message-ID: <1384797790.1791.10.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/3] ACPI / hotplug: Fix acpi_bus_get_device() return
 value check
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Mon, 18 Nov 2013 11:03:10 -0700
In-Reply-To: <1785834.mvVFipiyRh@vostro.rjw.lan>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan>
	 <1785834.mvVFipiyRh@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-14 at 00:15 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since acpi_bus_get_device() returns plain int and not acpi_status,
> ACPI_FAILURE() should not be used for checking its return value.  Fix
> that.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


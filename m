Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3KRSPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:15:20 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38214 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3KRSPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:15:17 -0500
Message-ID: <1384798238.1791.15.camel@misato.fc.hp.com>
Subject: Re: [PATCH 3/3] ACPI / PCI root: Clear driver_data before failing
 enumeration
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Mon, 18 Nov 2013 11:10:38 -0700
In-Reply-To: <6884617.gWRuZsFG3E@vostro.rjw.lan>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan>
	 <6884617.gWRuZsFG3E@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-14 at 00:17 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> If a PCI host bridge cannot be enumerated due to an error in
> pci_acpi_scan_root(), its ACPI device object's driver_data field
> has to be cleared by acpi_pci_root_add() before freeing the
> object pointed to by that field, or some later acpi_pci_find_root()
> checks that should fail may succeed and cause quite a bit of
> confusion to ensue.
> 
> Fix acpi_pci_root_add() to clear device->driver_data before
> returning an error code as appropriate.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689Ab3B0BCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:02:51 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:31683 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760242Ab3B0BCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:02:36 -0500
Message-ID: <1361926300.12845.102.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2, 0/7] ACPI / hotplug: Common code for ACPI-based
 hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Date: Tue, 26 Feb 2013 17:51:40 -0700
In-Reply-To: <3171747.TOMjvVkWL1@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
	 <3171747.TOMjvVkWL1@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 23:41 +0100, Rafael J. Wysocki wrote:
> On Sunday, February 17, 2013 04:18:31 PM Rafael J. Wysocki wrote:
> > Hi All,
> > 
> > The following patches introduce common code for ACPI-based hotplug for non-PCI
> > devices and modify the container and memory hotplug ACPI drivers to use the new
> > code.
> > 
> > This is based on linux-pm.git/master and regarded as v3.10 material.
> > 
> > [1/7] Introduce acpi_scan_match_handler() that will be useful going forward.
> > [2/7] Introduce common code for ACPI-base device hotplug.
> > [3/7] Use the new commot hotplug code in the container driver.
> > [4/7] Introduce acpi_scan_handler_matching() that will be useful subsequently.
> > [5/7] Introduce user space interface for hotplug profiles.
> > [6/7] Make the container driver use the hotplug profiles user space interface.
> > [7/7] Make the memory hotplug driver use struct acpi_scan_handler along with
> >       the hotplug profiles user space interface.
> 
> Following is the second iteration.  It takes all of the updates of patch [2/7]
> and the discussion of them into account and fixes the issue with 'enabled'
> working inversely in [5/7] spotted by Toshi Kani.

Thanks for all the updates.  Things look good now.  For the series:

Acked-by: Toshi Kani <toshi.kani@hp.com>
Tested-by: Toshi Kani <toshi.kani@hp.com>

-Toshi


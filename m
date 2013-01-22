Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3AVVe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:34:28 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:5216 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3AVVe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:34:26 -0500
Message-ID: <1358889867.14145.354.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Remove useless type argument of driver .remove()
 operation
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Tue, 22 Jan 2013 14:24:27 -0700
In-Reply-To: <1518653.CUpDmbmCI3@vostro.rjw.lan>
References: <1518653.CUpDmbmCI3@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-20 at 23:04 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The second argument of ACPI driver .remove() operation is only used
> by the ACPI processor driver and the value passed to that driver
> through it is always available from the given struct acpi_device
> object's removal_type field.  For this reason, the second ACPI driver
> .remove() argument is in fact useless, so drop it.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks for the clean-up!  It looks good. 

Acked-by: Toshi Kani <toshi.kani@hp.com>

-Toshi



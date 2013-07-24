Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3GXQG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:06:26 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46437 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3GXQGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:06:23 -0400
MIME-Version: 1.0
In-Reply-To: <6958813.eThhpoh5QO@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3215120.cRBBS5jciE@vostro.rjw.lan>
 <CAE9FiQURY5WFFJekPHV_s0HPi8uhKzSDOLSXHAkyLPf1=i8oAw@mail.gmail.com> <6958813.eThhpoh5QO@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 24 Jul 2013 10:06:01 -0600
Message-ID: <CAErSpo6z9CqCyLFbXpuJMtHHjLRNbo=gx87W_0_7TCHbvwrCRw@mail.gmail.com>
Subject: Re: [PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 6:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, July 23, 2013 07:20:53 PM Yinghai Lu wrote:
>> On Tue, Jul 23, 2013 at 2:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> [...]
>
>> [  102.631369] pci_host_bridge pci0000:00: freeing pci_host_bridge info
>
> By the way this looks fishy:
>
>> [  102.633091] ACPI: Device does not support D3cold

This and other printks in that function don't give any clue what
device is involved, even though we have an acpi_device pointer.  It'd
be nice to fix that, too.

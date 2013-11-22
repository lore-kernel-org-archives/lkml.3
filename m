Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3KVXLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:11:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59879 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755486Ab3KVXLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:11:41 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH] ACPI / scan: User direct recurrence for device hierarchy walks
Date: Sat, 23 Nov 2013 00:24:24 +0100
Message-ID: <3969579.ZtCX3j95ox@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1538742.Kb0j0zok76@vostro.rjw.lan>
References: <1538742.Kb0j0zok76@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 23, 2013 12:22:23 AM Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Rework acpi_bus_trim() and acpi_bus_device_attach(), which is
> renamed as acpi_bus_attach(), to walk the list of each device
> object's children directly and call themselves recursively for
> each child instead of using acpi_walk_namespace().  This
> simplifies the code quite a bit and avoids the overhead of
> callbacks and the ACPICA's internal processing which are not
> really necessary for these two routines.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Hi,
> 
> This is on top of the linux-pm/bleeding-edge branch that contains the series
> I posted previously: http://marc.info/?l=linux-pci&m=138470560909690&w=4

The subject should be "ACPI / scan: Use direct recurrence for device hierarchy
walks", sorry for the typo.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

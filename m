Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaEHO7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:59:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42657 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754835AbaEHO7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:59:39 -0400
Date: Thu, 8 May 2014 10:59:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/3] ACPI / PM: Avoid resuming devices in ACPI PM
 domain during system suspend
In-Reply-To: <2719001.qTQrFyBHGg@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405081058420.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Rework the ACPI PM domain's PM callbacks to avoid resuming devices
> during system suspend (in order to modify their wakeup settings etc.)
> if that isn't necessary.

Wasn't there going to be a patch in this series doing the same thing 
for PCI?  Or has it not yet been written?

Alan Stern


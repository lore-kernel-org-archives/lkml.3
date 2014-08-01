Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaHAOWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:22:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57826 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751008AbaHAOWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:22:01 -0400
Date: Fri, 1 Aug 2014 10:22:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Tenoutit, Faouaz" <faouaz.tenoutit@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V2] USB: Use ACPI device information
In-Reply-To: <140713857.5QYWLe1hHM@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1408011021120.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2014, Rafael J. Wysocki wrote:

> On Wednesday, July 09, 2014 04:42:38 PM Tenoutit, Faouaz wrote:
> > From: Faouaz TENOUTIT <faouaz.tenoutit@intel.com>
> > 
> > Use ACPI device pld information instead of calling
> > acpi_get_physical_device_location.
> > 
> > Signed-off-by: Faouaz TENOUTIT <faouaz.tenoutit@intel.com>
> > Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
> 
> Greg, Alan, any objections agains this?

No objection from me, aside from the fact that the posted patch was 
whitespace-damaged.

Acked-by: Alan Stern <stern@rowland.harvard.edu>


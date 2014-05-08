Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaEHTYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:24:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58343 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755254AbaEHTYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:24:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/3] ACPI / PM: Avoid resuming devices in ACPI PM domain during system suspend
Date: Thu, 08 May 2014 21:40:43 +0200
Message-ID: <1678557.ZOxSn5icam@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1405081058420.1087-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1405081058420.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 10:59:38 AM Alan Stern wrote:
> On Thu, 8 May 2014, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Rework the ACPI PM domain's PM callbacks to avoid resuming devices
> > during system suspend (in order to modify their wakeup settings etc.)
> > if that isn't necessary.
> 
> Wasn't there going to be a patch in this series doing the same thing 
> for PCI?  Or has it not yet been written?

Not yet written. :-)

Rafael


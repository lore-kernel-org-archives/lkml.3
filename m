Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaGVIzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:55:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:59219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaGVIzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:55:43 -0400
Date: Tue, 22 Jul 2014 10:55:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/3] ACPI / PM: Make ACPI-based PCI wakeup work for the
 "freeze" sleep state
Message-ID: <20140722085538.GA3935@laptop>
References: <1907495.agrCMfRsQN@vostro.rjw.lan>
 <9631666.En3K0jlGsY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9631666.En3K0jlGsY@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:23:29AM +0200, Rafael J. Wysocki wrote:

> That turned out to be more challenging than I had thought initially.
> 
> The last version I sent was almost OK, but it had some issues (like it could
> walk the PCI hierarchy before resuming any PCI devices during system resume),
> so a new version follows.  I did my best to avoid introducing any new problems
> with it, but I obviously might overlook something.
> 
> It works for me and doesn't seem to break anything as far as I can say.
> 
> [1/3] Make PM workqueue available for CONFIG_PM_RUNTIME unset.
> [2/3] Rework the handling of ACPI device wakeup notifications.
> [3/3] Enable wakeup GPEs while setting up devices for wakeup during system
>       suspend too.

Doesn't break, doesn't 'work' either. Is there anything I can provide
you with to make this easier? lspci output or anything like that?

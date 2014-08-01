Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbaHAUUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:20:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44292 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbaHAUUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:20:03 -0400
Date: Fri, 1 Aug 2014 22:20:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH v2] PM / sleep: Rename symbols, functions and variables
 related to sleep
Message-ID: <20140801202001.GA13738@amd.pavel.ucw.cz>
References: <5215142.eaz1Ajyth6@vostro.rjw.lan>
 <20140730065034.GB8024@amd.pavel.ucw.cz>
 <4200761.44Q8iqWhBp@vostro.rjw.lan>
 <74048613.5iSL8BqdeO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74048613.5iSL8BqdeO@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-08-01 16:33:12, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The names of several symbols, data types, functions and variables
> related to system sleep states are confusing and don't reflect the
> real behavior of those states correctly.
> 
> First of all, there generally are two sleep states that require
> platform support and one sleep state that is platform-independent.
> The first two of them are currently known as MEM and STANDBY,
> although these names really only match what the states do on full
> hardware ACPI compliant systems.  MEM in particular is supposed
> to mean "suspend-to-RAM", but in fact it means "the deepest sleep
> state available with platform support".  The definition of STANDBY
> is even more arbitrary.
> 
> Moreover, the remaining sleep state that doesn't need platform support
> is currently called FREEZE, which leads to double confusion with the
> process freezer (used during transitions to all sleep states) and
> with the freeze stage of processing devices during hibernation.
> 
> For these reasons, rename the PM_SUSPEND_MEM, PM_SUSPEND_STANDBY
> and PM_SUSPEND_FREEZE symbols to PM_SUSPEND_DEEP, PM_SUSPEND_SHALLOW
> and PM_IDLE_SLEEP, respectively, everywhere and rename data types,
> functions and variables related to those states to match the new names
> of the symbols.
> 
> This is a semi-mechanical replacement of names and it should not lead
> to any functional differences.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

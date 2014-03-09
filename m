Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaCIRAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:00:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63921 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751073AbaCIRAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:00:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [regression] linux-3.14.0-rc5-.. kernel does not switch power off
Date: Sun, 09 Mar 2014 18:15:38 +0100
Message-ID: <34025658.DfioqOCCn3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4824481.V0Gqxh5Nec@vostro.rjw.lan>
References: <CADDKRnCTBiGC2fkd1Utp7BY7vjORcHh4O9GgqfMP7iDfFkNKuw@mail.gmail.com> <4129487.hPye7CfaJv@vostro.rjw.lan> <4824481.V0Gqxh5Nec@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 09, 2014 05:58:59 PM Rafael J. Wysocki wrote:
> On Sunday, March 09, 2014 05:55:28 PM Rafael J. Wysocki wrote:
> > On Sunday, March 09, 2014 05:12:56 PM Jörg Otte wrote:
> > > On shutdown power is not switched off. The harddisk is already down.
> > > Reboot is working.
> > > 
> > > Last known good kernel is: 3.14.0-rc5-00265-gb01d4e6
> > > First known bad kernel is: 3.14.0-rc5-00287-gca62eec
> > 
> > Can you please tell me which commits those two kernels correspond to?
> 
> And please post a boot log from the failing one.

Never mind, I know what the problem is, commit 3130497f5bab (ACPI / sleep:
pm_power_off needs more sanity checks to be installed) has to be reverted.

Sorry about the breakage and I'll send a revert patch shortly.

Rafael


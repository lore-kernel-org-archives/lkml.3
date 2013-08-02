Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3HBTMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:12:55 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63477 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3HBTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <2052880.bHfzt6NKt5@vostro.rjw.lan>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan>
Date: Fri, 2 Aug 2013 14:12:49 -0500
Message-ID: <CAMP44s2a2HqohWL9d+i3cpifJiUfidTw_ZfO3PttvhMn_hGE1A@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 9:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> ---------------
>
> Colin Cross (1):
>       freezer: set PF_SUSPEND_TASK flag on tasks that call freeze_processes
>
> Lan Tianyu (1):
>       ACPI / battery: Fix parsing _BIX return value
>
> Rafael J. Wysocki (3):
>       Revert "cpuidle: Quickly notice prediction failure in general case"
>       Revert "cpuidle: Quickly notice prediction failure for repeat mode"
>       cpufreq: Fix cpufreq driver module refcount balance after suspend/resume
>
> ---------------

You forgot this patch:

https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=linux-next&id=3706231332d57072e0e2c0e59975443f3f18e673

Or do you think it's fine to boot these machines into a black screen?

-- 
Felipe Contreras

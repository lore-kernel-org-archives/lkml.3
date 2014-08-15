Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaHOWLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:11:34 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:59964 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaHOWLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ5Y-eZZz=SrkONt029eZ0AsEZ6xFhW4cmcaEVZ8=8Ls9r5+zA@mail.gmail.com>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
	<20140814205143.GY6758@twins.programming.kicks-ass.net>
	<CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
	<20140815061917.GX19379@twins.programming.kicks-ass.net>
	<CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
	<53EE0E5B.3050004@linux.intel.com>
	<53EE10CB.7040001@linux.intel.com>
	<CAJ5Y-eZiRyGroems7J2oH05ybbbivM-okm3gFz7Mkuu8ceeCDQ@mail.gmail.com>
	<53EE2BAA.1020603@linux.intel.com>
	<CAJ5Y-eZZz=SrkONt029eZ0AsEZ6xFhW4cmcaEVZ8=8Ls9r5+zA@mail.gmail.com>
Date: Fri, 15 Aug 2014 18:11:30 -0400
X-Google-Sender-Auth: anUR6BRl2RG5E-YJZKZxSDw_v70
Message-ID: <CAJvTdKn-NsubOqK9_BOvvmnF9C6cK5tUF22VbWXEaPyXzb0huQ@mail.gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
From: Len Brown <lenb@kernel.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux acpi <linux-acpi@vger.kernel.org>,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux team at Intel did not implement ACPI CPPC support
because we see no benefit to it over the native hardware interface on x86.

cheers,
Len Brown
Intel Open Source Technology Center

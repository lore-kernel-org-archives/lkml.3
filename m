Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaHOWWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:22:13 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:61211 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaHOWWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
Date: Fri, 15 Aug 2014 18:22:10 -0400
X-Google-Sender-Auth: rdq6kxGc73Q4j5Zt-HfZg1e7sDs
Message-ID: <CAJvTdK=hYS87BKZ0NcX7U3RJRmUHWGhC6krSTTmN8O2MO9BK=A@mail.gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
From: Len Brown <lenb@kernel.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.ne>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux acpi <linux-acpi@vger.kernel.org>,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I verified that CPU freq requests were taken by reading out the PERF_STATUS register.

Don't use the x86 PERF_STATUS register -- it will not tell you what
you want to know.

If you want to see the actual frequency, you need to watch how many
cycles elapse per a known time interval,
which is how intel_pstate and the turbostat utility do it.

cheers,
Len Brown
Intel Open Source Technology Center

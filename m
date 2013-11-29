Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3K2OPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:15:15 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:48924 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3K2OPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:15:12 -0500
MIME-Version: 1.0
In-Reply-To: <2707481.i2fpomAdZe@vostro.rjw.lan>
References: <0596aca2267741a8be74db4d19a191c417779629.1385698209.git.viresh.kumar@linaro.org>
	<697e564b93d1662514ac69e9c926904d3ff4f206.1385698209.git.viresh.kumar@linaro.org>
	<2707481.i2fpomAdZe@vostro.rjw.lan>
Date: Fri, 29 Nov 2013 19:45:11 +0530
X-Google-Sender-Auth: 9YmiWRDkcbpGK1Gwbgk4SGBk_SI
Message-ID: <CAOh2x=mqY5V2SyxmwQ-NePpQaAnpq_hKadNqaNKQQd+zxPL-0w@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] cpufreq: Mark x86 drivers with CPUFREQ_SKIP_INITIAL_FREQ_CHECK
 flag
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>, patches@linaro.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, ceh@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 7:25 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> I think you haven't missed any of them.
>
> That said, you need to do this in patch [1/2], or the kernel between
> patches [1/2] and [2/2] may be broken on some systems.
>
> If you want to do that in separate patches, the current [2/2] should be
> [1/2] and vice versa.
>
> I guess they will apply in the reverse order?

No, definition of CPUFREQ_SKIP_INITIAL_FREQ_CHECK would be
missing then after the first patch..

Anyway, I have fixed that and resent them now..

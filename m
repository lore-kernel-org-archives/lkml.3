Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaJQEqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 00:46:13 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:53513 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaJQEqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 00:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <20141016180355.GA14194@drone.musicnaut.iki.fi>
References: <1413357812-16895-1-git-send-email-keguang.zhang@gmail.com>
	<20141016180355.GA14194@drone.musicnaut.iki.fi>
Date: Fri, 17 Oct 2014 10:16:11 +0530
Message-ID: <CAKohpomjWt8fKU9=bT5fva+Qr_vJBg0cMWH1WcDFp_1NneV+qQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] cpufreq: Loongson1: Add cpufreq driver for Loongson1B (UPDATED)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Kelvin Cheung <keguang.zhang@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2014 23:33, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Why it's called "ls1x-cpufreq" instead of "loongson1_cpufreq"?

This is what Kelvin told me when I asked him the same query:

Other drivers of loongson1 are already named *ls1x*, such as
clk-ls1x.c and rtc-ls1x.c.
So I just keep pace with them.

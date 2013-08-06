Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3HFWcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:32:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58481 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab3HFWcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:32:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] cpufreq: loongson2: fix broken cpufreq
Date: Wed, 07 Aug 2013 00:43:02 +0200
Message-ID: <11577373.HKpXOatP90@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130806144012.GB17633@linux-mips.org>
References: <1375727232-17796-1-git-send-email-aaro.koskinen@iki.fi> <20130806144012.GB17633@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 04:40:12 PM Ralf Baechle wrote:
> On Mon, Aug 05, 2013 at 09:27:12PM +0300, Aaro Koskinen wrote:
> 
> > Commit 42913c799 (MIPS: Loongson2: Use clk API instead of direct
> > dereferences) broke the cpufreq functionality on Loongson2 boards:
> > clk_set_rate() is called before the CPU frequency table is initialized,
> > and therefore will always fail.
> > 
> > Fix by moving the clk_set_rate() after the table initialization.
> > Tested on Lemote FuLoong mini-PC.
> 
> Seems to make sense.
> 
> Rafael or Virish, this should go to Linus for 3.11.  Do you want to funnel
> this through the cpufreq tree or shall I send this to Linus with the
> next batch of MIPS stuff?

I've taken it already.

Thanks,
Rafael


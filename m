Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3HFOkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:40:31 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:51361 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab3HFOk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:40:27 -0400
Date: Tue, 6 Aug 2013 16:40:12 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Julia Lawall <Julia.Lawall@lip6.fr>, stable@vger.kernel.org
Subject: Re: [PATCH v2] cpufreq: loongson2: fix broken cpufreq
Message-ID: <20130806144012.GB17633@linux-mips.org>
References: <1375727232-17796-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375727232-17796-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 09:27:12PM +0300, Aaro Koskinen wrote:

> Commit 42913c799 (MIPS: Loongson2: Use clk API instead of direct
> dereferences) broke the cpufreq functionality on Loongson2 boards:
> clk_set_rate() is called before the CPU frequency table is initialized,
> and therefore will always fail.
> 
> Fix by moving the clk_set_rate() after the table initialization.
> Tested on Lemote FuLoong mini-PC.

Seems to make sense.

Rafael or Virish, this should go to Linus for 3.11.  Do you want to funnel
this through the cpufreq tree or shall I send this to Linus with the
next batch of MIPS stuff?

  Ralf

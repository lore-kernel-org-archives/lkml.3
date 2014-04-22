Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbaDVNoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:44:05 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:41426 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaDVNoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:44:02 -0400
MIME-Version: 1.0
In-Reply-To: <534C4EB8.9080704@semaphore.gr>
References: <534C4EB8.9080704@semaphore.gr>
Date: Tue, 22 Apr 2014 15:44:02 +0200
Message-ID: <CACRpkdZjcgC-9mgS7ZQDKOxPhCf720d2usdB+KzxqEMPcjSfiA@mail.gmail.com>
Subject: Re: [PATCH 15/20] mfd: db8500-prcmu: Use cpufreq_for_each_entry macro
 for iteration
From: Linus Walleij <linus.walleij@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:10 PM, Stratos Karafotis
<stratosk@semaphore.gr> wrote:

> The cpufreq core supports the cpufreq_for_each_entry macro helper
> for iteration over the cpufreq_frequency_table, so use it.
>
> It should have no functional changes.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

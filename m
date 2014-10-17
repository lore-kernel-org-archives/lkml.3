Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaJQIRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:17:46 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:58541 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaJQIRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:17:41 -0400
MIME-Version: 1.0
In-Reply-To: <1413527826-22906-1-git-send-email-keguang.zhang@gmail.com>
References: <1413527826-22906-1-git-send-email-keguang.zhang@gmail.com>
Date: Fri, 17 Oct 2014 13:47:40 +0530
Message-ID: <CAKohpo=iRubshWkv0xj6DDomeR-wdYs3y2QebCgW5u-dvu0J3g@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] cpufreq: Loongson1: Add cpufreq driver for Loongson1B
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2014 12:07, Kelvin Cheung <keguang.zhang@gmail.com> wrote:
> V2:
>    Use devm_clk_get() instead of clk_get().

Search for a few drivers which have used this API and understand how
to use it.

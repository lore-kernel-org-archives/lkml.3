Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbaDOEBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:01:16 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:37243 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaDOEBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:01:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140414232801.GF1877@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
	<b9bb3a40fc7a973438a54ddab8e1c89c6c66dd8c.1397492345.git.viresh.kumar@linaro.org>
	<20140414232801.GF1877@localhost.localdomain>
Date: Tue, 15 Apr 2014 09:31:14 +0530
Message-ID: <CAKohponWNXadiF0fKXMfx8MgSPh_T_odKVm-raGXuQPP7Nk5jA@mail.gmail.com>
Subject: Re: [PATCH 30/38] tick-sched: move nohz_full_buf[] inside tick_nohz_init()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 04:58, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> OTOH nohz_full_buf can have a big size and moving it to a local variable
> will result in big increase in kernel stack consumption.
>
> Keeping it static is safer.
>
> Also it's already __initdata so it's released after bootup. No issue of
> concurrent use either, so keeping it as is is fine.

Okay, this patch is dropped.

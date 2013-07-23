Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3GWEw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:52:57 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:60413 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3GWEw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:52:56 -0400
MIME-Version: 1.0
In-Reply-To: <51ECFBAC.7090900@ti.com>
References: <51ECFBAC.7090900@ti.com>
Date: Tue, 23 Jul 2013 01:52:55 -0300
Message-ID: <CAOMZO5AAz+O=Xtajc8uojMniEkzvXk-kT6QAUtMXTnmiqbS63g@mail.gmail.com>
Subject: Re: linux-3.11-rc1: Internal error: Oops - undefined instruction: 0
 [#1] SMP ARM on OMAP3/AM335x
From: Fabio Estevam <festevam@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: catalin.marinas@arm.com, Paul Walmsley <paul@pwsan.com>,
        Russell King <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Mesfin, Yebio" <ymesfin@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Mon, Jul 22, 2013 at 6:30 AM, Roger Quadros <rogerq@ti.com> wrote:
> Hi,
>
> I observe the following problem on booting v3.11-rc1 on OMAP3 beagle board.
>
> [    5.888946] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
> [    5.896057] Modules linked in:
> [    5.899322] CPU: 0 PID: 9 Comm: rcu_sched Not tainted 3.11.0-rc2-00001-g1ea701a #876
> [    5.907501] task: ce0720c0 ti: ce07a000 task.ti: ce07a000
> [    5.913208] PC is at check_and_switch_context+0x130/0x4dc
> [    5.918914] LR is at check_and_switch_context+0xd8/0x4dc

Got the same issue on a mx53 and prepared a fix. Will submit it shortly.

Regards,

Fabio Estevam

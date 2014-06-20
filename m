Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbaFTFl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:41:29 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:40880 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaFTFl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140619215140.348974921@linutronix.de>
References: <20140619214858.755664030@linutronix.de>
	<20140619215140.348974921@linutronix.de>
Date: Fri, 20 Jun 2014 11:11:28 +0530
X-Google-Sender-Auth: NBLGQz5U9-w0XkSpzwx-v2Z8BoE
Message-ID: <CAOh2x=niR4_jtWL2VRvZJ8LKkmW4fyNXB9+UzUKeRSagdm1xFw@mail.gmail.com>
Subject: Re: [patch 2/2] clk: spear3xx: Set proper clock parent of uart1/2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:22 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The uarts only work when the parent is ras_ahb_clk. The stale 3.5
> based ST tree does this in the board file.
>
> Add it to the clk init function. Not pretty, but the mess there is
> amazing anyway.

I still feel that board file is the right place to do it. Similar stuff might be
required for some other peripheral clocks later and this solution
wouldn't be scalable then.

But if you insist on doing it this way:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

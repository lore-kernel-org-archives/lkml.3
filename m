Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934772AbaFTJUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:20:12 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:59241 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934598AbaFTJUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:20:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140619212606.431750473@linutronix.de>
References: <20140619212606.431750473@linutronix.de>
Date: Fri, 20 Jun 2014 14:50:07 +0530
X-Google-Sender-Auth: y_yrsiOeyOj44iEW4YOUH4GG1CI
Message-ID: <CAOh2x=nYSzeb+fz1zA4-dQyD8jwzH69AEK5VyTTqhw_mNJgGEA@mail.gmail.com>
Subject: Re: [patch 00/13] irqchip: spear_shirq: Cleanup the bitrot
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The driver is broken for spear320 since commit 80515a5a(ARM: SPEAr3xx:
> shirq: simplify and move the shared irq multiplexor to DT). Clearly
> never tested on spear320.
>
> Aside of that it's an unreadable overengineered trainwreck with lots
> of obscure "functionality".
>
> Make it work and clean it up.
>
> Thanks,

For 1-7, 10 & 11

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

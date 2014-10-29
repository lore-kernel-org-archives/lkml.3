Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaJ2KOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:14:48 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:56360 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaJ2KOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:14:47 -0400
MIME-Version: 1.0
In-Reply-To: <1414232097-4328-3-git-send-email-marc.zyngier@arm.com>
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
	<1414232097-4328-3-git-send-email-marc.zyngier@arm.com>
Date: Wed, 29 Oct 2014 11:14:46 +0100
Message-ID: <CACRpkdZJBWF=JPksecB4UNxcYtjhybAUprhWHkdHzMpb6gchJQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] irqchip: GIC: Add support for irq_{get,set}_irqchip_state
From: Linus Walleij <linus.walleij@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Tin Huynh <tnhuynh@apm.com>, Y Vo <yvo@apm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Toan Le <toanle@apm.com>,
        Bjorn Andersson <bjorn@kryo.se>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 12:14 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:

> Add the required hooks for the internal state of an interrupt
> to be exposed to other subsystems.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

(...)
> +static void gic_poke_irq(struct irq_data *d, u32 offset)
> +static int gic_peek_irq(struct irq_data *d, u32 offset)

Awesome terminology Marc, very CBM BASIC v2 :)

Yours,
Linus Walleij

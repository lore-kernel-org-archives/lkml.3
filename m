Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbaKSTK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:10:57 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:62738 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166AbaKSTKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <544E30B6.7060902@arm.com>
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
	<1414232097-4328-2-git-send-email-marc.zyngier@arm.com>
	<alpine.DEB.2.11.1410252131110.5308@nanos>
	<alpine.DEB.2.11.1410252136220.5308@nanos>
	<544E30B6.7060902@arm.com>
Date: Wed, 19 Nov 2014 11:10:54 -0800
Message-ID: <CAJAp7OjupqU4YT_XeQJudoapSyjf2Pp=kRWZ=O+Yacm7ZYs6MQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] genirq: Allow the irqchip state of an IRQ to be save/restored
From: Bjorn Andersson <bjorn@kryo.se>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Phong Vo <pvo@apm.com>, Linus Walleij <linus.walleij@linaro.org>,
        Tin Huynh <tnhuynh@apm.com>, Y Vo <yvo@apm.com>,
        Toan Le <toanle@apm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 4:47 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
[...]
>
> Agreed, this makes a lot of sense. Will respin it.
>

Any update on this? I have a couple of drivers on the way that needs
this (querying level of an interrupt line).

Regards,
Bjorn

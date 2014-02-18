Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaBRHSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 02:18:50 -0500
Received: from mail-pb0-f65.google.com ([209.85.160.65]:34798 "EHLO
	mail-pb0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaBRHSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 02:18:49 -0500
MIME-Version: 1.0
Date: Tue, 18 Feb 2014 15:18:49 +0800
Message-ID: <CAC5e1FoD1+JUyNHv=91qDJB72Na6t=peuChsmQdRvkzehOvaiQ@mail.gmail.com>
Subject: Does it need to implement irq_set_type method in the ioapic_chip?
From: carl peng <carlpeng008@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sorry to bother you!
Does it need to implement irq_set_type method in the
ioapic_chip(arch/x86/kernel/apic/io_apic.c) structure?

Recently,  I developed a device driver based on x86. The device uses a
falling edge interrupt trigger mode, so I have to set the trigger mode
in the request_irq function, but found that it can not be set
successfully, it turn out to be that the irq_set_type method is not be
implemented in the ioapic_chip structure, that is to say, for APIC
interrupt controller, can not set the trigger mode.

So I would like to consult with you for two questions:
1. Does it need to implement irq_set_type method in the ioapic_chip structure?
2. if no need to implement it, how can device driver set the trigger
mode of APIC interrupt controller pin?

Thank you!
Carl

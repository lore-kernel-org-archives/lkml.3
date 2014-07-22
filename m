Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaGVVJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:09:53 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:43086 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaGVVJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:09:52 -0400
MIME-Version: 1.0
Date: Tue, 22 Jul 2014 17:09:51 -0400
Message-ID: <CAPDOMVinWFVKY=mMOA1f6pd4orOgcKh1kE01MPVaLZi0Z_tMmg@mail.gmail.com>
Subject: omap-wakeupgen.c: Remove function for fix me
From: Nick Krause <xerofoify@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static void __init irq_pm_init(void)
382 {
383         /* FIXME: Remove this when MPU OSWR support is added */
384         if (!soc_is_omap54xx())
385                 cpu_pm_register_notifier(&irq_notifier_block);
386 }
I am wondering is this omap supported now if it is can I remove it?
Cheers Nick

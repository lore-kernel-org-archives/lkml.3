Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3FLInt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:43:49 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41388 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3FLInr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:43:47 -0400
MIME-Version: 1.0
Date: Wed, 12 Jun 2013 14:13:46 +0530
Message-ID: <CAJ8eaTyKCvdR9MZ8aLgVU5TLtVVL_1M0gQET0C_GYbbkG=Wy6Q@mail.gmail.com>
Subject: Thumb Issue in ARM
From: naveen yadav <yad.naveen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,


We are facing one issue in user space, if we enable thumb mode and in kernel
whether we enable or disable thumb mode or code run in both scenario.
we could not understand the reason.

Our core is ARM cortex A15,
Kernel 3.8.13

One more issue if we disable THUMB in kernel we got undefined instruction in


11dffd:    ee7  7a00      vmov.f32        s15,#112    ;0x70

Thanks

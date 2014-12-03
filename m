Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaLCUYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:24:25 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:55241 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLCUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:24:24 -0500
X-ME-Helo: beldin
X-ME-Date: Wed, 03 Dec 2014 21:24:23 +0100
X-ME-IP: 109.214.46.91
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Daniel Mack <daniel@zonque.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: pxa: fix lubbock interrupts handling
References: <1417113721-9062-1-git-send-email-robert.jarzmik@free.fr>
	<alpine.DEB.2.11.1411272258010.3961@nanos> <87r3wn1mhu.fsf@free.fr>
	<CAN1soZzZ7nuvvHguaHVHZc8hXvv8SzvWY9Ejf-fYhA5yfbcM-w@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 03 Dec 2014 21:24:22 +0100
In-Reply-To: <CAN1soZzZ7nuvvHguaHVHZc8hXvv8SzvWY9Ejf-fYhA5yfbcM-w@mail.gmail.com>
	(Haojian Zhuang's message of "Sat, 29 Nov 2014 00:02:15 +0800")
Message-ID: <87r3wgzdl5.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haojian Zhuang <haojian.zhuang@gmail.com> writes:

>
> I think that it's a kind of irq muxing, just like lots of PMIC (power
> management IC).
> We should move the lubbock board irqs to a mfd driver, and register them as
> threaded irqs.
I will have a look.

I didn't consider mfd for motherboard gates, I'll think of it, thanks for the
idea.

Cheers.

-- 
Robert

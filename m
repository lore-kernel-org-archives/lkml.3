Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3KWVL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 16:11:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:37963 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab3KWVLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 16:11:25 -0500
Message-ID: <1385241054.4882.135.camel@pasglop>
Subject: Re: New build failures in v3.13-rc1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Anton Blanchard <anton@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Sun, 24 Nov 2013 08:10:54 +1100
In-Reply-To: <5290F68C.4060900@roeck-us.net>
References: <5290F68C.4060900@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-23 at 10:40 -0800, Guenter Roeck wrote:
> 
> According to Stephen introduced by commit 7c105b63b (powerpc: Add
> CONFIG_CPU_LITTLE_ENDIAN kernel config option).

We have a fix for that, I'll send it to Linus next week.

Cheers,
Ben.



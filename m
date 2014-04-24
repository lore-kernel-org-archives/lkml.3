Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaDXNTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:19:21 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:54438 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaDXNTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:19:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1404240918110.4704@ionos.tec.linutronix.de>
References: <1397443272-31467-1-git-send-email-yao.jin@linux.intel.com>
	<534B4C6D.5070003@linux.intel.com>
	<CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com>
	<5357A594.6050404@linux.intel.com>
	<CACRpkdYztACye5Xht3f4UuaWDA0gB7t2rgRmpTaL330YcxYhfQ@mail.gmail.com>
	<alpine.DEB.2.02.1404240918110.4704@ionos.tec.linutronix.de>
Date: Thu, 24 Apr 2014 15:19:18 +0200
Message-ID: <CACRpkdaHP4sp8fomE_7-2KaHAmBmTYv-cMSA=As04V54OZMo-g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-baytrail: workaround for irq descriptor conflict
 on ASUS T100TA
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Jin, Yao" <yao.jin@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 9:25 AM, Thomas Gleixner <tglx@linutronix.de> wrote:

> I'm traveling until friday, so please wait before you commit that
> fugly hack. I'll have a closer look how we can handle that at the core
> level.

Thanks a *lot* Thomas, I'll stand by for action.

Yours,
Linus Walleij

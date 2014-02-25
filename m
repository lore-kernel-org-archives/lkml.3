Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaBYSqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:46:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbaBYSqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:46:31 -0500
Message-ID: <1393353942.26583.10.camel@deneb.redhat.com>
Subject: Re: [PATCH v4 0/6] generic early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Dave Young <dyoung@redhat.com>, Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Date: Tue, 25 Feb 2014 13:45:42 -0500
In-Reply-To: <20140225183012.GA27164@mudshark.cambridge.arm.com>
References: <1392238575-10000-1-git-send-email-msalter@redhat.com>
	 <1393337404.7307.51.camel@deneb.redhat.com>
	 <20140225183012.GA27164@mudshark.cambridge.arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 18:30 +0000, Will Deacon wrote:
> I'd suggest spitting the core part out from the arch-specific parts. That
> way, the core part can merged independently and architectures can move over
> as they see fit. It also signals (at least to me) that, "hey, I should
> probably review this" whilst my current stance is "there's a whole load of
> stuff under mm/ that needs to be acked first".
> 
> If you put the whole thing into next, you just run the risk of conflicts
> with all the arch trees.

I've been thinking of breaking out the common bits and x86 bits and just
going with that for now. There's no point in just doing the common bits
because it won't get tested without at least one architecture using it.



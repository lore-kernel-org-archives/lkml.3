Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3AOD4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:56:54 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52289 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3AOD4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:56:53 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <50F19F3D.60502@gmail.com>
References: <50F19F3D.60502@gmail.com>
Date: Mon, 14 Jan 2013 19:56:52 -0800
Message-ID: <CAOesGMgrAdvRqrnanfRD1gvJ-4O6pT1n2ZR+TCZADjD1ED_+UA@mail.gmail.com>
Subject: Re: [GIT PULL] irqchip init infrastructure and GIC/VIC move
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 9:37 AM, Rob Herring <robherring2@gmail.com> wrote:
> Arnd, Olof,
>
> Please pull for 3.9. This is the initial infrastructure and conversion
> of the GIC and VIC to use it. Several people are waiting for the irqchip
> infrastructure to go in in order to convert other irqchip code over.
>
> I've left "static asmlinkage" in on the irq handlers. There's been no
> more discussion, so I think we are in agreement. If asmlinkage defines
> the procedure call convention for assembly calls, then it still makes
> sense to have it on a static function called thru a function pointer.
>
> Rob
>
> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:
>
>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
>
> are available in the git repository at:
>
>   git://sources.calxeda.com/kernel/linux.git tags/gic-vic-to-irqchip

Ugh. This conflicts heavily with the timer cleanup from Stephen, due
to adjacent changes in the machine descriptors.

I fixed them up, but I would appreciate a second glance at them for
sanity checking.


-Olof

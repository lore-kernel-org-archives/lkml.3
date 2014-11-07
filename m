Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaKGWpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:45:33 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48734 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKGWpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:45:31 -0500
MIME-Version: 1.0
In-Reply-To: <20141107041742.GH3698@titan.lakedaemon.net>
References: <1414624790-15690-1-git-send-email-abrestic@chromium.org>
	<1414624790-15690-4-git-send-email-abrestic@chromium.org>
	<20141107041742.GH3698@titan.lakedaemon.net>
Date: Fri, 7 Nov 2014 14:45:30 -0800
X-Google-Sender-Auth: qVXuNPjKbSS1dB4vrSRuBzW4FW0
Message-ID: <CAL1qeaFpA8Ar3ef4Utd94SVtVfzP2=HVKwDc-2XgWuV+6sWswQ@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] irqchip: mips-gic: Add device-tree support
From: Andrew Bresticker <abrestic@chromium.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 8:17 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Wed, Oct 29, 2014 at 04:19:49PM -0700, Andrew Bresticker wrote:
>> Add device-tree support for the MIPS GIC.  Update the GIC irqdomain's
>> xlate() callback to handle the three-cell specifier described in the
>> MIPS GIC binding document.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> Changes from v3:
>>  - use reserved-cpu-vectors property
>>  - read GIC base from CM if no reg property present
>> Changes from v2:
>>  - rebased on GIC irqchip cleanups
>>  - updated for change in bindings
>>  - only parse first CPU vector
>>  - allow platforms to use EIC mode
>> Changes from v1:
>>  - updated for change in bindings
>>  - set base address and enable bit in GCR_GIC_BASE
>> ---
>>  drivers/irqchip/irq-mips-gic.c | 92 +++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 87 insertions(+), 5 deletions(-)
>
> I assume this is going though the mips tree...
>
> Acked-by: Jason Cooper <jason@lakedaemon.net>

Yup, that's the plan.

Thanks,
Andrew

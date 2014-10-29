Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbaJ2RIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:08:14 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42429 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934301AbaJ2RIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <5450CAF9.3040902@imgtec.com>
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
	<1414541562-10076-3-git-send-email-abrestic@chromium.org>
	<5450CAF9.3040902@imgtec.com>
Date: Wed, 29 Oct 2014 10:08:10 -0700
X-Google-Sender-Auth: qvWeHwdp6N0IT_Kjuo74TkzRE4E
Message-ID: <CAL1qeaHEE43n6V-y6XECicPaoEAfTBpyfg8bYJZK0e-pSMAJjw@mail.gmail.com>
Subject: Re: [PATCH V3 2/4] of: Add binding document for MIPS GIC
From: Andrew Bresticker <abrestic@chromium.org>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 4:09 AM, Qais Yousef <qais.yousef@imgtec.com> wrote:
> On 10/29/2014 12:12 AM, Andrew Bresticker wrote:
>>
>> +- reg : Base address and length of the GIC registers.
>>
>
> Also except for sead3, the base address should be properly reported by the
> hardware. The size is fixed (for a specific version of GIC at least - which
> is also reported by the hardware). So it would be nice to make this
> optional.

Even though this is usually probable, I'd prefer to leave this as
required, or at least "optional, but recommended".  I don't have a
very strong opinion on it though, but perhaps the device-tree folks
do?

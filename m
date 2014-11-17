Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaKQV0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:26:33 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:36783 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKQV0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:26:31 -0500
MIME-Version: 1.0
In-Reply-To: <546A66EA.3090107@linaro.org>
References: <1415821419-26974-1-git-send-email-abrestic@chromium.org>
	<1415821419-26974-5-git-send-email-abrestic@chromium.org>
	<546A66EA.3090107@linaro.org>
Date: Mon, 17 Nov 2014 13:26:30 -0800
X-Google-Sender-Auth: Ua4fJoY3AKbKi06PJrGCvOTSEqc
Message-ID: <CAL1qeaHpK0a+ONK3bhVrRk-G7iwRw_HwpjtLwi6E6EJ+rccbww@mail.gmail.com>
Subject: Re: [PATCH V5 4/4] clocksource: mips-gic: Add device-tree support
From: Andrew Bresticker <abrestic@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, John Crispin <blogic@openwrt.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 1:21 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 11/12/2014 08:43 PM, Andrew Bresticker wrote:
>>
>> Parse the GIC timer frequency and interrupt from the device-tree.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
>
> Hi Andrew,
>
> through which tree is this patch supposed to go ?
>
> Is there any dependency ?

There are quite a few dependencies, so this series and all the other
MIPS GIC stuff is going through the MIPS tree.

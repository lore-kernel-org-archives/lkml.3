Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3A1QL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:11:57 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56094 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3A1QLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:11:55 -0500
MIME-Version: 1.0
In-Reply-To: <51069A3A.8090404@ti.com>
References: <1359112724-1217-1-git-send-email-prabhakar.lad@ti.com> <51069A3A.8090404@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 28 Jan 2013 21:41:33 +0530
Message-ID: <CA+V-a8vNjbt4RGR99m9LTB7ZsE-RjqSyEHOUPWHAr-7TEv-yug@mail.gmail.com>
Subject: Re: [PATCH] ARM: davinci: da850: add interrupt-parent property in soc node
To: Sekhar Nori <nsekhar@ti.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        devicetree-discuss@lists.ozlabs.org, Heiko Schocher <hs@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar,

On Mon, Jan 28, 2013 at 9:03 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 1/25/2013 4:48 PM, Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> This patch adds 'interrupt-parent' property in soc node, so that
>> the child inherits this property, this avoids adding 'interrupt-parent'
>> to each node.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: Heiko Schocher <hs@denx.de>
>> ---
>
> Looks good to me. Queuing for v3.9. BTW, we are moving the interrupt
> parent property to soc node rather than adding it. So, I think a better
> headline is "move interrupt-parent property to soc node". I change the
> headline while committing.
>
Thanks for fixing it.

Regards,
--Prabhakar

> Thanks,
> Sekhar

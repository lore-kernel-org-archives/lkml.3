Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3FRIso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:48:44 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47272 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3FRIpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <51C01BC3.4060100@ti.com>
References: <1371481078-18058-1-git-send-email-prabhakar.csengg@gmail.com> <51C01BC3.4060100@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 18 Jun 2013 14:15:13 +0530
Message-ID: <CA+V-a8szFcpxacZ3ERA3Sp7LP=fML3KaVyKtAL9K9tMwB3veNA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: edma: Convert to devm_* api
To: Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, Mark Brown <broonie@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Fernandes, Joel A" <joelagnel@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Tue, Jun 18, 2013 at 2:05 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 6/17/2013 8:27 PM, Prabhakar Lad wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> Use devm_ioremap_resource instead of reques_mem_region()/ioremap(),
>> devm_request_irq() instead of request_irq() and kzalloc() calls to
>> devm_kzalloc().
>>
>> This ensures more consistent error values and simplifies error paths.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Nice clean-up. The patch did not build since <linux/err.h> was not
> included. I fixed it locally and applied to v3.11/soc-2 branch of my tree.
>
Thanks for fixing it.

Regards,
--Prabhakar Lad

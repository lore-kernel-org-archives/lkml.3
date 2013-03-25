Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3CYKQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:16:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48544 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3CYKQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:16:14 -0400
MIME-Version: 1.0
In-Reply-To: <514FE307.5090201@ti.com>
References: <1363938793-22246-1-git-send-email-prabhakar.csengg@gmail.com>
 <1363938793-22246-3-git-send-email-prabhakar.csengg@gmail.com> <514FE307.5090201@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 25 Mar 2013 15:45:51 +0530
Message-ID: <CA+V-a8tShKHreai51GHsyfHvW5yCvEiEcTTks7Tsy0s54bEekQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: davinci: vpbe: venc: move the enabling of vpss
 clocks to driver
To: Sekhar Nori <nsekhar@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Mon, Mar 25, 2013 at 11:09 AM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 3/22/2013 1:23 PM, Prabhakar lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> The vpss clocks were enabled by calling a exported function from a driver
>> in a machine code. calling driver code from platform code is incorrect way.
>>
>> This patch fixes this issue and calls the function from driver code itself.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  Note: This patch is based on the comment from Sekhar
>>       (https://patchwork-mail1.kernel.org/patch/2278441/).
>>       Shekar I haven't completely removed the callback, I just added
>>       the function calls after the callback. As you mentioned just to
>>       pass the VPSS_CLK_CTRL as a resource to venc but the VPSS_CLK_CTRL
>>       is already being used by VPSS driver. I'll take this cleanup task later
>>       point of time.
>
> Fine by me.
>
Can I have your ACK on this patch ?

Regards,
--Prabhakar

> Thanks,
> Sekhar

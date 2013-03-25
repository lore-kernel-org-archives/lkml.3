Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3CYLSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:18:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55193 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab3CYLSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:18:23 -0400
Message-ID: <51503272.9070301@ti.com>
Date: Mon, 25 Mar 2013 16:48:10 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/2] media: davinci: vpbe: venc: move the enabling of
 vpss clocks to driver
References: <1363938793-22246-1-git-send-email-prabhakar.csengg@gmail.com> <1363938793-22246-3-git-send-email-prabhakar.csengg@gmail.com> <514FE307.5090201@ti.com> <CA+V-a8tShKHreai51GHsyfHvW5yCvEiEcTTks7Tsy0s54bEekQ@mail.gmail.com>
In-Reply-To: <CA+V-a8tShKHreai51GHsyfHvW5yCvEiEcTTks7Tsy0s54bEekQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2013 3:45 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> On Mon, Mar 25, 2013 at 11:09 AM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 3/22/2013 1:23 PM, Prabhakar lad wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> The vpss clocks were enabled by calling a exported function from a driver
>>> in a machine code. calling driver code from platform code is incorrect way.
>>>
>>> This patch fixes this issue and calls the function from driver code itself.
>>>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> ---
>>>  Note: This patch is based on the comment from Sekhar
>>>       (https://patchwork-mail1.kernel.org/patch/2278441/).
>>>       Shekar I haven't completely removed the callback, I just added
>>>       the function calls after the callback. As you mentioned just to
>>>       pass the VPSS_CLK_CTRL as a resource to venc but the VPSS_CLK_CTRL
>>>       is already being used by VPSS driver. I'll take this cleanup task later
>>>       point of time.
>>
>> Fine by me.
>>
> Can I have your ACK on this patch ?

The 'fine' from me was for the approach, not not patch ;). Seriously
though, since this patch is only touching media/ I haven't really done a
detailed enough review of it. In any case, it should be OK to merge this
without my ack.

Thanks,
Sekhar

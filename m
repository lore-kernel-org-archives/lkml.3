Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbaFSBtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:49:06 -0400
Received: from mail1.windriver.com ([147.11.146.13]:33574 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaFSBtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:49:05 -0400
Message-ID: <53A2416D.2090205@windriver.com>
Date: Thu, 19 Jun 2014 09:48:29 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB:gadget: Fix a warning while loading g_mass_storage
References: <Pine.LNX.4.44L0.1406171017090.1187-100000@iolanthe.rowland.org> <53A0E6A8.6070803@windriver.com> <xa1t7g4ev3uv.fsf@mina86.com>
In-Reply-To: <xa1t7g4ev3uv.fsf@mina86.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 07:44 PM, Michal Nazarewicz wrote:
> On Wed, Jun 18 2014, Yang,Wei wrote:
>> On 06/17/2014 10:18 PM, Alan Stern wrote:
>>> That is a strange question to ask.  If you did not know that I approved
>>> the patch, why did you insert my Acked-By:?
>> I added your Acked-By, as when you reviewed V3, you mentioned that I
>> *may* add your Acked-by in this patch. If I misunderstood your point, I
>> am so sorry for that.
> Alan's point is that if you have any doubts whether someone approves
> your patch you should *not* add their Acked-by.  So adding someone's
> Acked-by and then asking if they are fine with the patch is
> contradictory -- the former indicates that you believe the person is
> fine with the patch, while the latter shows that you aren't.
>
> Alan wrote:
>
>>>> With that change, you may add
>>>>
>>>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> so after adding “that change” you are in your right to add Alan's
> Acked-by, but what that also means is that Alan will be fine with the
> patch if you make the requested change, so you don't need to ask for an
> opinion again.
>
> PS. Note that “having any doubts” also means that if someone gave you
>      their Acked-by, but then you substantially rewrite the patch, you
>      probably should consider removing their Acked-by.
>
Michal, Thank you for your detailed explanation, it is very helpful to me.

Best Regards
Wei

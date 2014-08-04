Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaHDFuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 01:50:16 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:50448 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHDFuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 01:50:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVg4DYi99jQuZQ3pKbsmrMuzqeOOPscfhgp0HPdmOUvW4w@mail.gmail.com>
References: <1407122751-30689-1-git-send-email-xerofoify@gmail.com>
	<53DF1412.9010506@xs4all.nl>
	<CAPM=9tx-pkadgGJ98BuBHpkj=bvo+8ks76ro7UE5d=xWB4EN0A@mail.gmail.com>
	<CAPDOMVg4DYi99jQuZQ3pKbsmrMuzqeOOPscfhgp0HPdmOUvW4w@mail.gmail.com>
Date: Mon, 4 Aug 2014 01:50:13 -0400
Message-ID: <CAPDOMVjHfw6Edn7LWpiu7NSquCzwiu8-fexV-0pBztO0NZTEXQ@mail.gmail.com>
Subject: Re: [PATCH] v4l2: Change call of function in videobuf2-core.c
From: Nick Krause <xerofoify@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Udo van den Heuvel <udovdh@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 1:43 AM, Nick Krause <xerofoify@gmail.com> wrote:
> On Mon, Aug 4, 2014 at 1:38 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On 4 August 2014 15:03, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 08/04/2014 05:25 AM, Nicholas Krause wrote:
>>>> This patch changes the call of vb2_buffer_core to use VB2_BUFFER_STATE_ACTIVE
>>>> inside the for instead of not setting in correctly to VB2_BUFFER_STATE_ERROR.
>>>>
>>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>>
>>> Dunno what's going on here after reading Dave Airlie's reply, but:
>>>
>>
>> Nick has decided he wants to be a kernel developer, a laudable goal.
>>
>> He however has decided not to take any advice given to me by a number of other
>> kernel developers on how to work on the kernel. So instead he sends random
>> broken patches to random subsystems in the hope that one will slip past a sleepy
>> maintainer and end up in the kernel.
>>
>> He isn't willing to spend his own time learning anything, he is
>> expecting that kernel
>> developers want to spoon feed someone who sends them broken patches.
>>
>> We've asked him to stop, he keeps doing it, then when caught out apologizes
>> with something along the lines, of I'm trying to learn, "idiot
>> mistake", despite having
>> been told to take a step back and try and learn how the kernel works.
>>
>> Now we have to waste more maintainer time making sure nobody accidentally
>> merges anything he sends.
>>
>> Dave.
> All of my merges are not in the main kernel and have been revoked.
> Cheers Nick


Dave,
I understand your issues with my programming. I need to try and
understand the kernel first before programming
for it.
Regards Nick

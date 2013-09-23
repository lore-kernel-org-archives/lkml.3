Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3IWIbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:31:01 -0400
Received: from charon.rus.uni-stuttgart.de ([129.69.192.1]:33286 "EHLO
	charon.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734Ab3IWIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:31:00 -0400
Message-ID: <523FFC17.1090403@math.tu-berlin.de>
Date: Mon, 23 Sep 2013 10:30:15 +0200
From: Thomas Richter <thor@math.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: i835GM flicker on panning
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee> <alpine.SOC.1.00.1309211825490.9193@math.ut.ee> <4319_1379778790_523DC0E3_4319_13540_1_CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com> <523F2390.5030702@math.tu-berlin.de> <16566_1379880205_523F4D0D_16566_5011_1_CAKMK7uFNAhahpURH-LFj=x+8D2W7Z8y_-9OKhnJ_O4g7hyqu1Q@mail.gmail.com> <523F7020.702@math.tu-berlin.de> <17822_1379921548_523FEE8C_17822_1617_1_20130923073242.GA32145@phenom.ffwll.local>
In-Reply-To: <17822_1379921548_523FEE8C_17822_1617_1_20130923073242.GA32145@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel, hi others,

>> On 22.09.2013 22:03, Daniel Vetter wrote:
>>> Hm, that sounds a bit more like the ddx is having fun with rendering.
>>> Have you tried switching the backed from to either SNA or UXA? Also
>>> adding relevant mailing lists ...
>>>
>> No, whether I use uxa or sna makes no difference, same problem. I
>> don't think it's rendering related. The rendering is ok (except for
>> some defects in tuxracer if sna is used instead of uxa).
>
> Can you please test with
>
>         Option "LinearFramebuffer" "true"?

Did. Still flickers. I'm not quite sure, but it seems to me that there 
is at least one change (but allow me to test): If I'm now panning from 
left to right (move the mouse to the right), then the screen is stable. 
If I move it to the left, I get the flicker. Which is pretty strange.

Unless I'm completely mistaken, the tiled mode created flicker no matter 
whether I scrolled left to right or right to left, it just depended on 
the position. Wierd.

Greetings,
	Thomas


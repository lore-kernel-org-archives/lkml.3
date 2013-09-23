Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab3IWKVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:21:35 -0400
Received: from charon.rus.uni-stuttgart.de ([129.69.192.1]:59570 "EHLO
	charon.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393Ab3IWKVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:21:34 -0400
Message-ID: <5240162A.2030404@math.tu-berlin.de>
Date: Mon, 23 Sep 2013 12:21:30 +0200
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

Hi folks,

> Can you please test with
>
>         Option "LinearFramebuffer" "true"?
>
> Thanks, Daniel

Tested again. Yes, indeed, LinearFramebuffer does make a difference. 
Without it, panning to the right causes flicker, with it, moving the 
mouse to the right - panning right (thus scrolling the screen to the 
left) causes no flicker. Scrolling into the other direction always 
causes flicker, no matter what.

Greetings,
	Thomas

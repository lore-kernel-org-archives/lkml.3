Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaCMKRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:17:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61286 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaCMKRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:17:09 -0400
Message-ID: <532185A0.3020007@gmail.com>
Date: Thu, 13 Mar 2014 10:17:04 +0000
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: dts: berlin2q: add the Marvell Armada 1500 pro
 (BG2Q) device tree
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com> <1394622364-6848-2-git-send-email-antoine.tenart@free-electrons.com> <20140312122210.GA3040@piout.net> <532180E0.9060108@gmail.com> <20140313100838.GA4418@piout.net>
In-Reply-To: <20140313100838.GA4418@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 10:08 AM, Alexandre Belloni wrote:
> On 13/03/2014 at 09:56:48 +0000, Sebastian Hesselbarth wrote :
>> On 03/12/2014 12:22 PM, Alexandre Belloni wrote:
>>>
>>> The 25MHz crystal is on the board, please move it to the board dts.
>>
>> If you can confirm that sysmgr clock comes directly from this crystal,
>> I agree. If it is fed into a pll and can possibly be modified or gated,
>> make it depend on a 25MHz board crystal. If 25MHz is the only option
>> for this clock input, I could also live with it being part of the SoC
>> description.
>>
>
> Yeah, after more discussion, the 25 MHz crystl is the only option and it
> is fed to an oscillator that generate the reference clock for the PLLs.
> It is probably fine to let it in the dtsi.
>

Fine, I am planing to do more work on Berlin and especially clocks next
cycle. So most of the fixed-clocks will vanish anyway.

BTW, back at ELCE/ARM summit I successfully enabled SMP for berlin2.
I'll dig that patch out for you to re-test on Quad-core bg2q.

Sebastian

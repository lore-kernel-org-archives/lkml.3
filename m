Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaLRP7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:59:12 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:53199 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLRP7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:59:11 -0500
Message-ID: <5492F9A4.3070805@i2se.com>
Date: Thu, 18 Dec 2014 16:58:28 +0100
From: Stefan Wahren <stefan.wahren@i2se.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: Fabio Estevam <festevam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac registers
References: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com> <CAOMZO5CQjpYtrNTT65-ikJua4N_osYj4UVgm3EV+sEvVWF59cg@mail.gmail.com> <5491379F.3090607@i2se.com> <201412171700.52323.marex@denx.de>
In-Reply-To: <201412171700.52323.marex@denx.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:11J4OzC96tBCJHkFLKlRejnnRsby8Uk7yqpyeFJaduRPqUVMsZo
 d8HEP6d1BQtfom5cSdQMQKyh05QkkJsdlBBzVXkhMQSEIKEuS1wetpQ2MylsTAVC29zeZYk
 2V12vAl2q4H2VYo1vZVLoDfG492xGPC+EDKaxluctPk77tzFAsDgWsGJo+U+103VGPIJyli
 VeKtemeDwtNmtrNJHttBA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

Am 17.12.2014 um 17:00 schrieb Marek Vasut:
> On Wednesday, December 17, 2014 at 08:58:23 AM, Stefan Wahren wrote:
>> Hi Fabio,
>>
>> Am 17.12.2014 um 03:44 schrieb Fabio Estevam:
>>> Hi Stefan,
>>>
>>> On Sun, Dec 14, 2014 at 3:16 PM, Stefan Wahren <stefan.wahren@i2se.com> 
> wrote:
>>>> Btw i hope this patch also fixes a SPI communication issue with our
>>>> hardware which forces us to bypass ref_io1 for ssp2.
>>> Does this patch fix the SPI issue?
>> unfortunately not. If the 3.19-rc1 has been released, i send the fixed
>> patch.
>>
>> I've the theory that's an initialization issue. I've never heard of SPI
>> problems from the U-Boot users and we are using imx-bootlets.
>>
>> I'll try to test it with U-Boot.
> Please keep me in the loop, I'd be interested in what you find. Thanks!
>
> Best regards,
> Marek Vasut

i tested it with U-Boot, but the issue still exists. If there is any
progress, i'll inform you.

Stefan


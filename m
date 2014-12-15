Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaLOHUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:20:15 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:54406 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaLOHUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:20:13 -0500
Message-ID: <548E8B88.8040100@i2se.com>
Date: Mon, 15 Dec 2014 08:19:36 +0100
From: Stefan Wahren <stefan.wahren@i2se.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: linux-kernel@vger.kernel.org, festevam@gmail.com, shawn.guo@linaro.org,
        mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac registers
References: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com> <201412141712.12589.marex@denx.de> <1638147247.144508.1418577377536.JavaMail.open-xchange@oxbaltgw03.schlund.de> <201412142019.50047.marex@denx.de>
In-Reply-To: <201412142019.50047.marex@denx.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:dvf5Zwo2WY1CVC/7hbo0/5gKI/sPEz8CSW7CiAZ4tmsZfZ0iOtu
 /3HNLV3HExBYQib6Ru/YNwtYdwpmnM6TE9dsND2ifszZ1ztUwQwlkOw92CK8P9Oc25zDa8w
 35mck0U8PdJ04866TVz8ihBSnt1hA8/IgWdkBUKte7FBmtShdfnb2mlzISzUpOx7NqBX4St
 2utCd9pCjEjvsg4QboKCQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 14.12.2014 um 20:19 schrieb Marek Vasut:
> On Sunday, December 14, 2014 at 06:16:17 PM, Stefan Wahren wrote:
>>> [...]
>>>
>>> Also, it might be a good idea to zap the 0x3f mask and use HEX and DEC
>>> numbers consistently, but this is an idea for another patch.
>> Yes.
>>
>> Btw i hope this patch also fixes a SPI communication issue with our
>> hardware which forces us to bypass ref_io1 for ssp2.
>> But i will have access to that hardware tomorrow.
> Which issue would that be please ? 

i've posted the issue in the Freescale Community [1].

> What are the symptoms ?

Bits from the SPI slave are misinterpreted.

BR Stefan

[1] - https://community.freescale.com/thread/310434

>
> Best regards,
> Marek Vasut



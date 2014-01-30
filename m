Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaA3RKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:10:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38017 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbaA3RKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:10:44 -0500
Message-ID: <52EA8765.1050200@ti.com>
Date: Thu, 30 Jan 2014 19:09:57 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: keystone: dts: disable "msmcsram" clock
References: <1391082343-13371-1-git-send-email-ivan.khoronzhuk@ti.com> <448912EABC71F84BBCADFD3C67C4BE52A0B4B6@DBDE04.ent.ti.com> <52EA5A8F.7070107@ti.com> <52EA6228.8030008@ti.com>
In-Reply-To: <52EA6228.8030008@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I will send v2

On 01/30/2014 04:31 PM, Santosh Shilimkar wrote:
> On Thursday 30 January 2014 08:58 AM, Ivan Khoronzhuk wrote:
>> Ok. I will delete node for this clock from DT and send v1
>>
> Sorry for the html reply first of all. That node should never have
> been actually added since the clock is not suppose to be touched even
> in low power states. Change log should say something like this ...
>
> "MSMC is the coherency interconnect and all the coherent masters are
> connected to it including devices which are not under Linux OS control.
> MSMC clock should not be toched even in low power states."
>
> So drop the clock node o.w without 'clk_ignore_unused' will disable
> the clock leading to system stall.
>
> I wil try get these in rc's since its a bug fix
>
> Regards,
> Santosh
>
>
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbaDVSIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:08:23 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62024 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbaDVSIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:08:20 -0400
Message-ID: <5356B00F.8040109@gmail.com>
Date: Tue, 22 Apr 2014 20:08:15 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add GPIO nodes for Berlin BG2 and BG2CD
References: <1397724329-14154-1-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1397724329-14154-1-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 10:45 AM, Antoine Ténart wrote:
> After adding support for the Berlin BG2Q GPIOs, this series uses the
> same GPIO dwapb driver to support the Berlin BG2 and BG2CD GPIOs.
> 
> Applies on top of Sebastian's for-next branch[1].
> 
> [1] https://github.com/shesselba/linux-berlin/commits/berlin/for-next
> 
> Antoine Ténart (2):
>   ARM: dts: berlin: add the BG2 GPIO nodes
>   ARM: dts: berlin: add the BG2CD GPIO nodes
> 
>  arch/arm/boot/dts/berlin2.dtsi   | 105 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/berlin2cd.dtsi | 102 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 207 insertions(+)
> 

Both applied to berlin/dt.

Thanks!

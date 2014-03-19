Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbaCSM1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:27:52 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52790 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964928AbaCSM1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:27:50 -0400
Message-ID: <53298E3E.5060803@gmail.com>
Date: Wed, 19 Mar 2014 13:31:58 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] ARM: dts: berlin2q: add the Marvell BG2-Q DMP
 device tree
References: <1395153167-21029-1-git-send-email-antoine.tenart@free-electrons.com> <1395153167-21029-4-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1395153167-21029-4-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 03:32 PM, Antoine Ténart wrote:
> Adds initial support for the Marvell BG2-Q DMP. The board has 2GB of
> memory, an uart activated and what's initially supported by the Marvell
> Armada 1500 pro dtsi.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/boot/dts/Makefile                 |  3 ++-
>   arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 28 ++++++++++++++++++++++++++++
>   2 files changed, 30 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm/boot/dts/berlin2q-marvell-dmp.dts

Applied to berlin/dt.

Sebastian


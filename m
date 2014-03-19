Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956AbaCSM1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:27:18 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:65468 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832AbaCSM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:27:16 -0400
Message-ID: <53298E1D.1060606@gmail.com>
Date: Wed, 19 Mar 2014 13:31:25 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] ARM: berlin2q: add the Marvell Armada 1500 pro
 in the documentation
References: <1395153167-21029-1-git-send-email-antoine.tenart@free-electrons.com> <1395153167-21029-3-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1395153167-21029-3-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 03:32 PM, Antoine Ténart wrote:
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   Documentation/arm/Marvell/README                         | 5 +++++

Applied to berlin/soc.

>   Documentation/devicetree/bindings/arm/marvell,berlin.txt | 1 +

Squashed into previous patch.

In the future, please keep dts/binding doc changes strictly
separated from other changes. This is not a big deal, so I took
care of it myself (I haven't been clear anyway).

Sebastian


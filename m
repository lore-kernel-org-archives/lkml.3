Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbaFYPAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:00:14 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47173 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaFYPAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:00:12 -0400
Message-ID: <53AAE3F2.9060809@gmail.com>
Date: Wed, 25 Jun 2014 17:00:02 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] ARM: berlin: add SMP support
References: <1401897826-11711-1-git-send-email-antoine.tenart@free-electrons.com> <1401897826-11711-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1401897826-11711-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 06:03 PM, Antoine Ténart wrote:
> Adds SMP support for Berlin SoCs. Secondary CPUs are reset, then
> execute the instruction we put in the reset exception register, setting
> the pc at the address contained in the software reset address register,
> which is the physical address of the Berlin secondary startup.
>
> This implementation avoid using the pen lock mechanism.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

Applied to berlin/soc with Andrew's Reviewed-by.

Thanks!


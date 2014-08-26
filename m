Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbaHZNkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:40:51 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52203 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaHZNks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:40:48 -0400
Message-ID: <53FC8E5A.9030404@gmail.com>
Date: Tue, 26 Aug 2014 15:40:42 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 7/8] ARM: berlin: add the AHCI node for the BG2Q
References: <1406744041-1269-1-git-send-email-antoine.tenart@free-electrons.com> <1406744041-1269-8-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1406744041-1269-8-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 08:14 PM, Antoine Ténart wrote:
> The BG2Q has an AHCI SATA controller. Add the corresponding nodes
> (AHCI, PHY) into its device tree.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2q.dtsi | 39 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 39 insertions(+)

Applied to berlin/dt.

Thanks for the patience!

Sebastian



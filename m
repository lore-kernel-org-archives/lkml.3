Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbaHZNlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:41:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63845 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaHZNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:41:03 -0400
Message-ID: <53FC8E6A.8020008@gmail.com>
Date: Tue, 26 Aug 2014 15:40:58 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 8/8] ARM: berlin: enable the eSATA interface on the
 BG2Q DMP
References: <1406744041-1269-1-git-send-email-antoine.tenart@free-electrons.com> <1406744041-1269-9-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1406744041-1269-9-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 08:14 PM, Antoine Ténart wrote:
> The BG2Q has an AHCI SATA controller with an eSATA interface. Enable it.
> Only enable the first port, the BG2Q DMP does not support the second one.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>   arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 8 ++++++++
>   1 file changed, 8 insertions(+)

Applied to berlin/dt.

Thanks for the patience!

Sebastian


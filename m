Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbaAJQBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:01:09 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41475 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaAJQBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:01:07 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-12-52d01941b16d
Message-id: <52D0193A.30301@samsung.com>
Date: Fri, 10 Jan 2014 17:00:58 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 6/8 v3] ARM: dts: exynos5250/5420: add dt node for sss
 module
References: <1389243621-13245-1-git-send-email-ch.naveen@samsung.com>
 <1389354291-32051-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389354291-32051-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7qOkheCDF62SFrcfX6Y0eLlIU2L
	7lcyFr0LrrJZ3L/3k8ni8q45bBYzzu9jsli07T+zxapdfxgtzs45xOTA5bFz1l12j20HVD36
	tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY+njnYwFc1grGto3MDUwLmbpYuTkkBAwkfh0YBcb
	hC0mceHeeiCbi0NIYCmjxPGPTewgCSGBz4wSh6ZJdjFycPAKaEg86pMHMVkEVCV2tdiAVLAJ
	qEl8bngENkZUIELi77z1jCA2r4CgxI/J98BWiQiUS/y7sQZsPLPAAUaJddNPgTUICwRLnDiy
	jQVibyNQ4sJ5sG5OATeJLxfaWEFsZgFriZWTtjFC2PISm9e8ZZ7AKDALyZJZSMpmISlbwMi8
	ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMk5L/sYFx8zOoQowAHoxIPb4DIhSAh1sSy4src
	Q4wSHMxKIrzXBIFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGNdMXrPDq0rmnV7+85BvJrv4Z+v/
	iPvt/yhMwkahl+P8w4uvmSx+Kz3UY1VLc9K8f517049HK1c5rT1zVHJiXM4SX00+N7bwRpXV
	LcX3W+VqGDQvntzGp5uXeufnI2um+alLNbd5/cjbl/O1QPuCS3OSIpPg7i9ndtrcC110L+sx
	q/lWTslvcUosxRmJhlrMRcWJAKY7Se9XAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 10.01.2014 12:44, Naveen Krishna Chatradhi wrote:
> This patch adds the device tree node for SSS module
> found on Exynos5420 and Exynos5250
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v2:
> 1. Added device tree node for SSS on Exynos5250 aswell
>
>   arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
>   arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>   2 files changed, 18 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaLDM7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:59:39 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:59588 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaLDM7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:59:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wang Long <long.wanglong@huawei.com>, xuwei5@hisilicon.com,
        yanhaifeng@gmail.com, zhangfei.gao@linaro.org,
        haojian.zhuang@linaro.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, jason@lakedaemon.net,
        jh80.chung@samsung.com, khilman@linaro.org, lee.jones@linaro.org,
        linux@arm.linux.org.uk, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, obh+dt@kernel.org, olof@lixom.net,
        pawel.moll@arm.com, swarren@nvidia.com,
        thomas.petazzoni@free-electrons.com, huxinwei@huawei.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        peifeiyue@huawei.com
Subject: Re: [PATCH 0/7] ARM: hisi: enable HiP01 SoC
Date: Thu, 04 Dec 2014 13:58:52 +0100
Message-ID: <3601066.g7Jvjk5UFL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
References: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:BDoOrbx/BpI7f1h2ioglMkdEEDbGHbmusAS+Z518uZ5hQRVcSTU
 NzH1/A1tkihgc9Ro23MyzP9QsUA6el9qMtEM6lMxPndmq7zA+VW7VQlFCHr5u8t6mpf7spU
 Y0jB07p7yjUDRa9KfCvnkuORhPsTlHzBkKiGcXvip7SgxRg2sqY2IougmDebBqVoE5QlO4G
 oiqZltcPu5hL8WHu4C47Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 02:15:43 Wang Long wrote:
> This series patch enable Hisilicon HiP01 SoC. The HiP01 SoC series
> chip is designed for networking product, it integrates a rich peripheral
> interfaces to support network applications and supports both one 
> core or dual cores and quad cores. The core is Cortex A9. 

Sorry for the delay in my reply. The patches look good to me, but I'm
not sure what you expect to happen to them. You have a number of
people listed as recipients, but it's not clear if you expect any of
us to apply them into a git tree.

Is Xu Wei going to pick these up in a git tree and send a pull request
to arm@kernel.org?

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaFYMRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:17:46 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54649 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaFYMRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:17:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v2 1/2] Documentation: Document Hisilicon hix5hd2 sata PHY
Date: Wed, 25 Jun 2014 14:16:49 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Kishon Vijay Abraham I <kishon@ti.com>, mark.rutland@arm.com,
        haifeng.yan@linaro.org, jchxue@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Jiancheng Xue <xuejiancheng@huawei.com>
References: <1403687648-29082-1-git-send-email-zhangfei.gao@linaro.org> <1403687648-29082-2-git-send-email-zhangfei.gao@linaro.org>
In-Reply-To: <1403687648-29082-2-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201406251416.49561.arnd@arndb.de>
X-Provags-ID: V02:K0:2IBgHJjOAJYyUlrBv9Gd+mLYagJMgO7GkmruSuUNgTi
 Fh40Cf9CjlwA/gXX7TlljDq2ge14jhcCj/PZQK8547E8aoxcN0
 emKAUR1gouwq2/MtTABRUoSwl7NJsv+Fhroa8vJEavOijGTxE7
 nqGRxkHd8g0mHG9zekPwJOM8w0MyzOKQqm0D35PoxPbd0HMnvJ
 xaM9v16QnQ1hSOS+urRFXSk060xBfjv6dE3RVjvJnxmjLLLU8G
 HOQY1/DJyuUvVFgnqFDPeb1DYPDIQOI1gHUsX82FDAfrc5hI24
 H/Da8BCAspGsT0z24LxZB2O9i9XDVCAz4tjCQ7WbLFkEyWkUG2
 UzbX4bxidqojPDqoQY0A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2014, Zhangfei Gao wrote:
> From: Jiancheng Xue <xuejiancheng@huawei.com>
> 
> Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.
> 
> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>

We have had a couple of PHY drivers that were initially meant to be
single-purpose but then turned out to be for hardware that could
be put into multiple modes (SATA, gbit ethernet, PCIe, ...). Are
you sure that this particular device is SATA-only?

	Arnd

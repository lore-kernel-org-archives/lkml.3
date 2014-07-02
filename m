Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaGBLU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:20:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45904 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaGBLU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:20:56 -0400
Message-ID: <53B3EAE2.4040101@ti.com>
Date: Wed, 2 Jul 2014 16:50:02 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Zhangfei Gao <zhangfei.gao@linaro.org>, <arnd@arndb.de>,
        <mark.rutland@arm.com>, <haifeng.yan@linaro.org>, <jchxue@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Jiancheng Xue <xuejiancheng@huawei.com>
Subject: Re: [PATCH v2 1/2] Documentation: Document Hisilicon hix5hd2 sata
 PHY
References: <1403687648-29082-1-git-send-email-zhangfei.gao@linaro.org> <1403687648-29082-2-git-send-email-zhangfei.gao@linaro.org>
In-Reply-To: <1403687648-29082-2-git-send-email-zhangfei.gao@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 25 June 2014 02:44 PM, Zhangfei Gao wrote:
> From: Jiancheng Xue <xuejiancheng@huawei.com>
> 
> Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.
> 
> Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
>  .../devicetree/bindings/phy/hix5hd2-sata-phy.txt   |   22 ++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
> 
> diff --git a/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt b/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
> new file mode 100644
> index 0000000..296168b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt

Generally we have a single file for a SoC while adding phy binding
documentation. So just make it hix5hd2-phy.txt.

Thanks
Kishon

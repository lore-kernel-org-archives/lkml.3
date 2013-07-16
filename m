Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab3GPP2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:28:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44727 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab3GPP2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:28:38 -0400
Message-ID: <51E56670.6020802@ti.com>
Date: Tue, 16 Jul 2013 20:57:44 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <linux@arm.linux.org.uk>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, Joel Fernandes <joelf@ti.com>,
        <arnd@arndb.de>, <prabhakar.csengg@gmail.com>,
        <yongjun_wei@trendmicro.com.cn>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ARM: edma: remove duplicated include from edma.c
References: <CAPgLHd_j_JmDOsGSwLO_eBZnWteMzLVKJa93fY2iaSe31Ozo_w@mail.gmail.com>
In-Reply-To: <CAPgLHd_j_JmDOsGSwLO_eBZnWteMzLVKJa93fY2iaSe31Ozo_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/2013 7:28 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Sending this for inclusion in v3.11-rc2. This is technically a clean-up,
but this is still -rc1, so lets see.

Thanks,
Sekhar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbaGAJTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:19:49 -0400
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:12913 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbaGAJTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:19:48 -0400
Message-ID: <53B27D28.7090908@de.bosch.com>
Date: Tue, 1 Jul 2014 11:19:36 +0200
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <mathieu.poirier@linaro.org>
CC: <linus.walleij@linaro.org>, <will.deacon@arm.com>,
        <linux@arm.linux.org.uk>, <daniel.thompson@linaro.org>,
        <robherring2@gmail.com>, <robbelibobban@gmail.com>, <Al.Grant@arm.com>,
        <patches@linaro.org>, <marcin.jabrzyk@gmail.com>,
        <linux-kernel@vger.kernel.org>, <arnd@linaro.org>,
        <panchaxari.prasannamurthy@linaro.org>, <r.sengupta@samsung.com>,
        <arve@android.com>, <Tony.Armitstead@arm.com>,
        <john.stultz@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <james.king@linaro.org>, <pratikp@codeaurora.org>, <varshney@ti.com>,
        <jonas.svennebring@avagotech.com>
Subject: Re: [PATCH 8/9 v2] coresight: adding basic support for Vexpress TC2
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org> <1403892261-25026-9-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1403892261-25026-9-git-send-email-mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.211.33]
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.06.2014 20:04, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>
> Support for the 2 PTMs, 3 ETMs, funnel, TPIU and replicator
> connected to the ETB are included.  Proper handling of the
> ITM and the replicator linked to it along with the CTIs
> and SWO are not included.
>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>   arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts | 174 +++++++++++++++++++++++++++++
>   1 file changed, 174 insertions(+)
>
> diff --git a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
> index 15f98cb..390f2bb 100644
> --- a/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
> +++ b/arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts
...
> +	funnel {
> +		compatible = "arm,coresight-funnel", "arm,primecell";
...
> +			 * repicator but configured as par of the funnel.

Two typos here?

repicator -> replicator

as par -> as part

Best regards

Dirk



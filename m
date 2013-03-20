Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3CTLXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:23:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57821 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab3CTLX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:23:28 -0400
Message-ID: <51499C29.6070405@ti.com>
Date: Wed, 20 Mar 2013 16:53:21 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 2/7] ARM: tegra: update device trees for USB binding rework
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <1363609781-4045-3-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1363609781-4045-3-git-send-email-vbyravarasu@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 18 March 2013 05:59 PM, Venu Byravarasu wrote:
> This patch updates all Tegra board files so that they contain all the
> properties required by the updated USB DT binding. Note that this patch
> only adds the new properties and does not yet remove the old properties,
> in order to maintain bisectability. The old properties will be removed
> once the driver has been updated to assume the new bindings.
>
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>   arch/arm/boot/dts/tegra20-colibri-512.dtsi |    4 +++
>   arch/arm/boot/dts/tegra20-harmony.dts      |    8 +++---
>   arch/arm/boot/dts/tegra20-iris-512.dts     |    4 +++
>   arch/arm/boot/dts/tegra20-paz00.dts        |    8 +++---
>   arch/arm/boot/dts/tegra20-seaboard.dts     |   13 +++++++---
>   arch/arm/boot/dts/tegra20-trimslice.dts    |   12 +++++++---
>   arch/arm/boot/dts/tegra20-ventana.dts      |    7 +++--
>   arch/arm/boot/dts/tegra20.dtsi             |   32 +++++++++++++++++----------
>   8 files changed, 57 insertions(+), 31 deletions(-)
>
> diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> index cb73e62..af5a7ae 100644
> --- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> +++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
> @@ -443,6 +443,10 @@
>   		nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */
>   	};
>
> +	usb-phy@c5004000 {
This node doesn't have a *reg* property. So "@c5004000" is not needed. 
This comment applies to all the nodes which doesn't have *reg* property.

Thanks
Kishon

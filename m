Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3ISORl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:17:41 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:55694 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3ISORi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:17:38 -0400
Message-ID: <523B0782.7050501@cogentembedded.com>
Date: Thu, 19 Sep 2013 18:17:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, bcousson@baylibre.com, tony@atomide.com,
        devicetree@vger.kernel.org, balajitk@ti.com,
        linux-kernel@vger.kernel.org, kishon@ti.com, linux-ide@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 12/15] ARM: dts: omap5: add ocp2scp1 address resource
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379597019-15294-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1379597019-15294-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 05:23 PM, Roger Quadros wrote:

> Add OCP2SCP1 module address space.

> CC: Benoit Cousson <bcousson@baylibre.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   arch/arm/boot/dts/omap5.dtsi |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 06aa665..8a88a94 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -663,6 +663,7 @@
>   			#size-cells = <1>;
>   			ranges;
>   			ti,hwmods = "ocp2scp1";
> +			reg = <0x4a080000 0x1f>;

    Are you sure length is not 0x20?

WBR, Sergei


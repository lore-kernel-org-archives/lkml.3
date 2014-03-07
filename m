Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaCGPpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:45:25 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58564 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaCGPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:45:22 -0500
Message-ID: <5319F7AA.7040305@cogentembedded.com>
Date: Fri, 07 Mar 2014 19:45:30 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>, linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 1/5] r8a7790.dtsi: add vin[0-3] nodes
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk> <1394197299-17528-2-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1394197299-17528-2-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/07/2014 04:01 PM, Ben Dooks wrote:

> Add nodes for the four video input channels on the R8A7790.

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

    This patch should have been preceded by the VIN driver patch and bindings 
description, don't you think?

> diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
> index a1e7c39..4c3eafb 100644
> --- a/arch/arm/boot/dts/r8a7790.dtsi
> +++ b/arch/arm/boot/dts/r8a7790.dtsi
> @@ -395,6 +395,38 @@
>   		status = "disabled";
>   	};
>
> +	vin0: vin@0xe6ef0000 {

    ePAPR standard [1] tells us that:

The name of a node should be somewhat generic, reflecting the function of the 
device and not its precise programming model.

    So, I would suggest something like "video". And remove "0x" from the 
address part of the node name please.

WBR, Sergei


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbaF3Ukt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:40:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36103 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaF3Ukq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:40:46 -0400
Message-ID: <53B1CB4B.7050706@wwwdotorg.org>
Date: Mon, 30 Jun 2014 14:40:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        edubezval@gmail.com, thierry.reding@gmail.com, pdeschrijver@nvidia.com,
        mlongnecker@nvidia.com
CC: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] of: Add bindings for nvidia,tegra124-soctherm
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-3-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1403856699-2140-3-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 02:11 AM, Mikko Perttunen wrote:
> This adds binding documentation and headers for the Tegra124
> SOCTHERM device tree node.

> diff --git a/Documentation/devicetree/bindings/thermal/tegra-soctherm.txt b/Documentation/devicetree/bindings/thermal/tegra-soctherm.txt

> +Required properties :
...
> +- #thermal-sensor-cells : For thermctl sensors. Should be 1.

I'd prefer a tiny bit more information here: A link to whatever other
document defines the meaning of #thermal-sensor-cells, and a link to the
header that defines the meaning of the data in the cell. Perhaps:

#thermal-sensor-cells : Should be 1. See ./thermal.txt for a description
of this property. See <dt-bindings/thermal/tegra124-soctherm.h> for a
list of valid values.

> diff --git a/include/dt-bindings/thermal/tegra124-soctherm.h b/include/dt-bindings/thermal/tegra124-soctherm.h
> +#endif
> +
> +

There are a couple of blank lines at the end of that file.


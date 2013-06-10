Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3FJJWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:22:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4479 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3FJJWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:22:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 10 Jun 2013 02:22:19 -0700
Message-ID: <51B59B81.8040208@nvidia.com>
Date: Mon, 10 Jun 2013 14:55:21 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: "b-cousson@ti.com" <b-cousson@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: Re: [PATCH v2 1/2] ARM: dts: add dtsi for palmas
References: <1370855059-5342-1-git-send-email-j-keerthy@ti.com> <1370855059-5342-2-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1370855059-5342-2-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013 02:34 PM, J Keerthy wrote:
> Adds palmas mfd and palmas regulator nodes.
>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>   arch/arm/boot/dts/palmas.dtsi |   98 +++++++++++++++++++++++++++++++++++++++++

Hi Keerthy,
Can you please add documentation for dt binding:
Documentation/devicetree/bindings/mfd

Most of time we refer from this document for dt population.

Thanks,
Laxman

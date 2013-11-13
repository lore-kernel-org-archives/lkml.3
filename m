Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab3KMLkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:40:09 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10518 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759050Ab3KMLkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:40:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Nov 2013 03:34:26 -0800
Message-ID: <528364C6.80207@nvidia.com>
Date: Wed, 13 Nov 2013 17:08:46 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: fixed: fix regulator_list_voltage() for regression
References: <Pine.LNX.4.64.1311131228030.18879@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1311131228030.18879@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 November 2013 05:03 PM, Guennadi Liakhovetski wrote:
> Commit c368e5fc2a190923b786f2de3e79430ea3566a25 "regulator: fixed:
> get rid of {get|list}_voltage()" broke regulator_list_voltage() for
> the fixed regulator, because an earlier commit
> 5a523605afa7d3b54b2e7041f8c9e6bc39872a7e "regulator: core: provide
> fixed voltage in desc for single voltage rail" missed to add support
> for the fixed-voltage special case to that function. This patch
> fixes that regression.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---

I tested the regulator_get_voltage() API only, not other APIs which uses 
regulator_list_voltage().
I think this patch is fine.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>



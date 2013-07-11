Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3GKLZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:25:39 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52621 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3GKLZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:25:37 -0400
Date: Thu, 11 Jul 2013 12:25:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        sameo@linux.intel.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Subject: Re: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
Message-ID: <20130711112531.GJ25601@gmail.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jun 2013, Keerthy wrote:

> From: J Keerthy <j-keerthy@ti.com>
> 
> Check if irq value obtained is valid. If it is not valid
> then skip the irq request step and go ahead with the probe.
> 
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>  drivers/mfd/palmas.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Applied with Stephen and Mark's RB.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

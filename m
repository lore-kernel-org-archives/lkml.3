Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3HMK2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:28:11 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33595 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3HMK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:28:07 -0400
Date: Tue, 13 Aug 2013 11:27:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, swarren@wwwdotorg.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        rob@landley.net, grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gg@slimlogic.co.uk, kishon@ti.com, j-keerthy@ti.com,
        ian.campbell@citrix.com
Subject: Re: [PATCH V2 2/3] mfd: palmas: add support for external control
 configuration
Message-ID: <20130813102757.GA15278@lee--X1>
References: <1376380392-19723-1-git-send-email-ldewangan@nvidia.com>
 <1376380392-19723-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376380392-19723-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some of Palmas resources like clock, SMPSs, LDOs etc can be controlled
> by external pins ENABLE1, ENABLE2 or NSLEEP.
> 
> Add support to configure these resources to externally controlled.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> Fix typos: palams ->palmas
> 
>  drivers/mfd/palmas.c       |   97 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/palmas.h |   49 ++++++++++++++++++++++
>  2 files changed, 146 insertions(+), 0 deletions(-)

Patch looks good to me. Unless anyone else has an opinion:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

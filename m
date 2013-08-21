Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3HURQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:16:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33309 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3HURQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:16:08 -0400
Message-ID: <5214F5D3.5060705@wwwdotorg.org>
Date: Wed, 21 Aug 2013 11:16:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        lee.jones@linaro.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        j-keerthy@ti.com, ian.campbell@citrix.com
Subject: Re: [PATCH V4] regulator: palmas: add support for external control
 of rails
References: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 04:48 AM, Laxman Dewangan wrote:
> Palmas rails like LDOs, SMPSs, REGENs, SYSENs can be enable and disable
> by register programming through I2C communication as well as it can be
> enable/disable with the external control input ENABLE1, ENABLE2 and NSLEEP.
> 
> Add support for configuring these rails to be controlled by external control
> inputs. This is require to configure the rail's control register as well as
> configuration of resource register.
> 
> Provide the external input names through parameter "roof-floor". Updated the
> DT binding document to details different value of the roof-floor.

The binding change looks reasonable to me, so that part,
Acked-by: Stephen Warren <swarren@nvidia.com>

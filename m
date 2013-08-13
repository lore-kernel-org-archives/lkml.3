Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab3HMTPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:15:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59806 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab3HMTPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:15:07 -0400
Message-ID: <520A85B6.8060901@wwwdotorg.org>
Date: Tue, 13 Aug 2013 13:15:02 -0600
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
Subject: Re: [PATCH V2 3/3] regulator: palmas: add support for external control
 of rails
References: <1376380392-19723-1-git-send-email-ldewangan@nvidia.com> <1376380392-19723-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1376380392-19723-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 01:53 AM, Laxman Dewangan wrote:
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

Please see my comments on V1; I think the binding modification should be
backwards-compatible.

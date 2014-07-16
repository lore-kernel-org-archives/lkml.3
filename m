Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333AbaGPNxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:53:46 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58893 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933362AbaGPNxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:53:44 -0400
Message-ID: <53C683E5.90604@mm-sol.com>
Date: Wed, 16 Jul 2014 16:53:41 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: pramod.gurav.etc@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Josh Cartwright <joshc@codeaurora.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>   <53C66AEB.7030906@mm-sol.com> <1405512867.75389776@apps.rackspace.com>  <53C66F3B.9020507@mm-sol.com> <1405515375.452411340@apps.rackspace.com>
In-Reply-To: <1405515375.452411340@apps.rackspace.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

> 
> Thanks.
> I misunderstood the Kconfig documentation which says, "Reverse dependencies can only be used with boolean or tristate symbols". In the note following this statement doc says, "In general use select only for non-visible symbols".
> 
> The CONFIG_SPMI option is visible in menuconfig hence either it should be set by default in multi_v7_defconfig(like in qcom_defconfig) or driver owner should mention a 'depneds on CONFIG_SPMI' as suggested by Lars-Peter Clausen. 
> I prefer the former (defconfig).
> 
> Shall I send a new patch adding it in multi_v7_defconfig?

yes, I think it should be enabled. On the other side I'm not sure that
it will be acceptable because presently there are no users if it in
multi platform build. Might be worth to do it ones the MFD driver is in.

And I/we should add a dependency to SPMI in the MFD driver as Lars
pointed out.

-- 
regards,
Stan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3JIQNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:13:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33118 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3JIQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:13:34 -0400
Message-ID: <525580A8.5050902@wwwdotorg.org>
Date: Wed, 09 Oct 2013 10:13:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, lee.jones@linaro.org,
        sameo@linux.intel.com, broonie@kernel.org, linus.walleij@linaro.org,
        akpm@linux-foundation.org
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        rtc-linux@googlegroups.com, rob.herring@calxeda.com,
        mark.rutland@arm.com, pawel.moll@arm.com, rob@landley.net,
        ijc+devicetree@hellion.org.uk, grant.likely@linaro.org,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V5 1/3] mfd: add support for ams AS3722 PMIC
References: <1381321761-8898-1-git-send-email-ldewangan@nvidia.com> <1381321761-8898-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1381321761-8898-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 06:29 AM, Laxman Dewangan wrote:
> The ams AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
> controller, 11 LDOs, RTC, automatic battery, temperature and
> over-current monitoring, 8 GPIOs, ADC and a watchdog.
> 
> Add MFD core driver for the AS3722 to support core functionality.

OK, I think the binding here is about clear enough, so the binding,
Acked-by: Stephen Warren <swarren@nvidia.com>

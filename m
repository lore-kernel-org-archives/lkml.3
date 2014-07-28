Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaG1QBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:01:22 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:18903 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751003AbaG1QBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:01:21 -0400
Message-ID: <53D673C9.2070005@arm.com>
Date: Mon, 28 Jul 2014 17:01:13 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] irqchip: gic-v3: Only define gic_peek_irq() when building
 SMP
References: <1406480224-24628-1-git-send-email-broonie@kernel.org>
In-Reply-To: <1406480224-24628-1-git-send-email-broonie@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/07/14 17:57, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> If building with CONFIG_SMP disbled (for example, with allnoconfig) then
> GCC complains that the static function gic_peek_irq() is defined but not
> used since the only reference is in the SMP initialisation code. Fix this
> by moving the function definition inside the ifdef.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>

Looks sane to me.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...

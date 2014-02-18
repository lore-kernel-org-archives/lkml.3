Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaBRIWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 03:22:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47605 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbaBRIWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 03:22:38 -0500
Message-ID: <53031828.20000@ti.com>
Date: Tue, 18 Feb 2014 13:52:00 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Keerthy <j-keerthy@ti.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <grant.likely@linaro.org>, <lgirdwood@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] Regulators: TPS65218: Add Regulator driver for
 TPS65218 PMIC
References: <1391665814-18814-1-git-send-email-j-keerthy@ti.com> <1391665814-18814-4-git-send-email-j-keerthy@ti.com> <20140214202108.GI4451@sirena.org.uk>
In-Reply-To: <20140214202108.GI4451@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 February 2014 01:51 AM, Mark Brown wrote:
> On Thu, Feb 06, 2014 at 11:20:13AM +0530, Keerthy wrote:
>> This patch adds support for TPS65218 PMIC regulators.
>>
>> The regulators set consists of 6 DCDCs and 1 LDO. The output
>> voltages are configurable and are meant to supply power to the
>> main processor and other components.
> Applied, thanks.  Please use subject lines consistent with the
> subsystem.
Sure. Thanks a lot Mark.

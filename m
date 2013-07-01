Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3GAKGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:06:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41985 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3GAKGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:06:24 -0400
Message-ID: <51D1548E.4080008@ti.com>
Date: Mon, 1 Jul 2013 15:36:06 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>,
        <sameo@linux.intel.com>, <j-keerthy@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] regulator: palmas: model SMPS10 as two regulators
References: <1372672182-14778-1-git-send-email-kishon@ti.com> <20130701100136.GA27646@sirena.org.uk>
In-Reply-To: <20130701100136.GA27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 01 July 2013 03:31 PM, Mark Brown wrote:
> On Mon, Jul 01, 2013 at 03:19:42PM +0530, Kishon Vijay Abraham I wrote:
>> SMPS10 has two outputs OUT1 and OUT2 and have one input IN1.
>> SMPS10-OUT2 is connected to SMPS10-IN1 and can be configured either
>> in BOOST mode or BYPASS mode. regulator_enable of SMPS10-OUT2 configures
>> it in BOOST mode. For BYPASS mode regulator_allow_bypass() API can be
>> used. SMPS10-OUT1 is connected to SMPS10-OUT2 and can be enabled using
>> regulator_enable().
>
> This doesn't apply...

Ok. Which tree/branch should it be based on?. I created it on next-20130628
as base.

Thanks
Kishon

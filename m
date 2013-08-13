Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab3HMNNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:13:25 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10225 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab3HMNNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:13:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 13 Aug 2013 06:13:22 -0700
Message-ID: <520A3467.20203@nvidia.com>
Date: Tue, 13 Aug 2013 18:58:07 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>
Subject: Re: [PATCH V3 3/3] pinctrl: palmas: add pincontrol driver
References: <1375794755-6246-1-git-send-email-ldewangan@nvidia.com> <1375794755-6246-4-git-send-email-ldewangan@nvidia.com> <5201467D.9020803@wwwdotorg.org>
In-Reply-To: <5201467D.9020803@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wednesday 07 August 2013 12:24 AM, Stephen Warren wrote:
> On 08/06/2013 07:12 AM, Laxman Dewangan wrote:
>> TI Palmas series Power Management IC have multiple pins which can be
>> configured for different functionality. This pins can be configured
>> for different function. Also their properties like pull up/down,
>> open drain enable/disable are configurable.
>>
>> Add support for pincontrol driver Palmas series device like TPS65913,
>> TPS80036. The driver supports to be register from DT only.
> I think this binding is reasonable enough, so that part,
>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Can you please review this series?
I have some follow on patches on cleanups of tegra pincontrol driver to 
use the utils function which is introduced on this series which I want 
to send.

Thanks,
Laxman

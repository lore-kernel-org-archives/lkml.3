Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3FNMa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:30:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11379 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3FNMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:30:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 14 Jun 2013 05:29:08 -0700
Message-ID: <51BB0DC9.3090809@nvidia.com>
Date: Fri, 14 Jun 2013 18:04:17 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
CC: Mark Brown <broonie@kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>, Keerthy <a0393675@ti.com>
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
References: <20130604093816.GY31367@sirena.org.uk> <51ADB6BF.6020205@ti.com> <20130604100511.GA31367@sirena.org.uk> <51B5A14E.6000500@ti.com> <20130610100330.GO31367@sirena.org.uk> <51B5B268.8090908@ti.com> <20130610124924.GU31367@sirena.org.uk> <51B8345F.601@nvidia.com> <20130612141409.GE1403@sirena.org.uk> <bcb26ab704763c7ae7ef815b8fa0f652@slimlogic.co.uk> <20130612145126.GG1403@sirena.org.uk> <feb8849eb7c84a17fd53da28df0f82e7@slimlogic.co.uk>
In-Reply-To: <feb8849eb7c84a17fd53da28df0f82e7@slimlogic.co.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013 08:53 PM, gg@slimlogic.co.uk wrote:
> On 2013-06-12 15:51, Mark Brown wrote:
>> On Wed, Jun 12, 2013 at 03:31:09PM +0100, gg@slimlogic.co.uk wrote:
>>> On 2013-06-12 15:14, Mark Brown wrote:
>>>> Yes, that seems like the most obvious thing here as far as I can tell
>>> >from the frankly fragmented and obscure information but given all the
>>>> confusion that seems to exist among the people working on the driver
>>>> it's really not clear if there's something else going on.
>>> What about the case where they are inputs? For bus power?
>> So the current flow can change direction here?
> Just rechecked the data sheet and it looks like that use-case has
> actually been
> removed from more recent data sheets.
>
> So ignore me, yes now it can be modelled by two regulators!

Thanks for concluding on this.

Kishon,
Are you going to send new patch for splitting this regulator or should I 
send for this?

This will help on populating dts file what Keerthi is sending and also 
to me for the tegra platform.


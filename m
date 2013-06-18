Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3FRI2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:28:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52807 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab3FRI2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:28:09 -0400
Message-ID: <51C01A07.7030805@ti.com>
Date: Tue, 18 Jun 2013 13:57:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>, Mark Brown <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>, Keerthy <a0393675@ti.com>
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
References: <20130604093816.GY31367@sirena.org.uk> <51ADB6BF.6020205@ti.com> <20130604100511.GA31367@sirena.org.uk> <51B5A14E.6000500@ti.com> <20130610100330.GO31367@sirena.org.uk> <51B5B268.8090908@ti.com> <20130610124924.GU31367@sirena.org.uk> <51B8345F.601@nvidia.com> <20130612141409.GE1403@sirena.org.uk> <bcb26ab704763c7ae7ef815b8fa0f652@slimlogic.co.uk> <20130612145126.GG1403@sirena.org.uk> <feb8849eb7c84a17fd53da28df0f82e7@slimlogic.co.uk> <51BB0DC9.3090809@nvidia.com>
In-Reply-To: <51BB0DC9.3090809@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 14 June 2013 06:04 PM, Laxman Dewangan wrote:
> On Wednesday 12 June 2013 08:53 PM, gg@slimlogic.co.uk wrote:
>> On 2013-06-12 15:51, Mark Brown wrote:
>>> On Wed, Jun 12, 2013 at 03:31:09PM +0100, gg@slimlogic.co.uk wrote:
>>>> On 2013-06-12 15:14, Mark Brown wrote:
>>>>> Yes, that seems like the most obvious thing here as far as I can tell
>>>> >from the frankly fragmented and obscure information but given all the
>>>>> confusion that seems to exist among the people working on the driver
>>>>> it's really not clear if there's something else going on.
>>>> What about the case where they are inputs? For bus power?
>>> So the current flow can change direction here?
>> Just rechecked the data sheet and it looks like that use-case has
>> actually been
>> removed from more recent data sheets.
>>
>> So ignore me, yes now it can be modelled by two regulators!
>
> Thanks for concluding on this.
>
> Kishon,
> Are you going to send new patch for splitting this regulator or should I
> send for this?

I'll send by today or tomorrow.

Thanks
Kishon

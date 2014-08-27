Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517AbaH0PgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:36:14 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16808 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935358AbaH0PgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:36:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 27 Aug 2014 08:21:54 -0700
Message-ID: <53FDFAE7.7020407@nvidia.com>
Date: Wed, 27 Aug 2014 18:36:07 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>,
        Juha-Matti Tilli <juha-matti.tilli@iki.fi>
CC: <rui.zhang@intel.com>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 0/4] Tegra124 soctherm driver
References: <1408616242-21009-1-git-send-email-mperttunen@nvidia.com> <20140821122011.GA99564@sandfort.unics.fi> <20140821160127.GA17621@developer>
In-Reply-To: <20140821160127.GA17621@developer>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moi Eduardo,

can you ack this series or is there still something to do?

Thanks,
Mikko

On 21/08/14 19:01, Eduardo Valentin wrote:
> Hello Juha-Matti,
>
> On Thu, Aug 21, 2014 at 03:20:11PM +0300, Juha-Matti Tilli wrote:
>> On Thu, Aug 21, 2014 at 01:17:18PM +0300, Mikko Perttunen wrote:
>>> this series adds support for the thermal monitoring features of the
>>> soctherm unit on the Tegra124 SoC.
>>
>> For all patches in this series:
>>
>> Reviewed-by: Juha-Matti Tilli <jtilli@nvidia.com>
>> Tested-by: Juha-Matti Tilli <jtilli@nvidia.com>
>
> I suppose the 4 C to 5 C difference is not seen anymore in this version,
> right?
>
> Cheers,
>
> Eduardo
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

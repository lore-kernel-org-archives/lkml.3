Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaESPpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:45:11 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39642 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaESPpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:45:09 -0400
Message-ID: <537A26FD.2010808@samsung.com>
Date: Tue, 20 May 2014 00:45:01 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        sajjan.linux@gmail.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        arnd@arndb.de, marc.zyngier@arm.com, t.figa@samsung.com,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        thomas.abraham@linaro.org, ben-linux@fluff.org, olof@lixom.net,
        chanho61.park@samsung.com, sachin.kamat@linaro.org,
        linux-arm-kernel@lists.infradead.org, tushar.behera@linaro.org
Subject: Re: [PATCHv5 0/5] Support new Exynos3250 SoC based on Cortex-A7 dual
 core
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com> <5374426B.6000505@samsung.com> <5379ECBF.9010706@gmail.com> <5379ED6B.8060309@gmail.com>
In-Reply-To: <5379ED6B.8060309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/14 20:39, Tomasz Figa wrote:
>
>
> On 19.05.2014 13:36, Tomasz Figa wrote:
>> Hi Kukjin, Chanwoo,
>>
>> On 15.05.2014 06:28, Chanwoo Choi wrote:
>>> Dear Kukjin,
>>>
>>> Could you please pick following patches?
>>> - [PATCHv5 1/5] ARM: EXYNOS: Add Exynos3250 SoC ID
>>> - [PATCHv5 2/5] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
>>
>> I'd say that [PATCHv5 5/5] ARM: dts: Add device tree sources for
>> Exynos3250 would be also useful. :)
>
> Aha, it is already applied. I should have checked in the tree first. Sorry.
>
No problem and I applied this without any reply...

I'm thinking the way to add soc_is_exynosOOOO() for new SoC and just 
holding it on including 5260, 5800 as well.

Any updates, I'll let you know.

Thanks,
Kukjin

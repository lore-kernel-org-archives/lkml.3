Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbbANMRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:17:53 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:33211 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbbANMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:17:51 -0500
Message-ID: <54B65E44.7060901@st.com>
Date: Wed, 14 Jan 2015 13:17:08 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <peter.griffin@linaro.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <patrice.chotard@st.com>,
        <peppe.cavallaro@st.com>, <kishon@ti.com>, <arnd@arndb.de>,
        <lee.jones@linaro.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] Fix sti drivers whcih mix reg address spaces
References: <1420643052-4506-1-git-send-email-peter.griffin@linaro.org> <20150111.185445.1288456704842706068.davem@davemloft.net>
In-Reply-To: <20150111.185445.1288456704842706068.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_04:2015-01-14,2015-01-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
On 01/12/2015 12:54 AM, David Miller wrote:
> From: Peter Griffin <peter.griffin@linaro.org>
> Date: Wed,  7 Jan 2015 15:04:05 +0000
>
>> A V2 of this old series incorporating Arnd and Lees Feedback form v1.
>>
>> Following on from Arnds comments about the picophy driver here
>> https://lkml.org/lkml/2014/11/13/161, this series fixes the
>> remaining upstreamed drivers for STI, which are mixing address spaces
>> in the reg property. We do this in a way similar to the keystone
>> and bcm7445 platforms, by having sysconfig phandle/ offset pair
>> (where only one register is required). Or phandle / integer array
>> where multiple offsets in the same bank are needed).
>>
>> This series breaks DT compatability! But the platform support
>> is WIP and only being used by the few developers who are upstreaming
>> support for it. I've made each change to the driver / dt doc / dt
>> file as a single atomic commit so the kernel will remain bisectable.
>>
>> This series then also enables the picophy driver, and adds back in
>> the ehci/ohci dt nodes for stih410 which make use of the picophy.
> Series applied to net-next, thanks.
Did you apply all the series to net-next?

I need the DT patches in STi SoC tree, that will go to Linus tree via 
arm-soc, hopefully for v3.20.

How could we synchronize?
Maybe I could create an immutable tag on top of STi DT branch, which is 
based on top of v3.19-rc1,
that you would merge in your tree?

Please let me know your preferred way.

Thanks,
Maxime


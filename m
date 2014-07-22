Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaGVQks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:40:48 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37730 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755985AbaGVQkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:40:46 -0400
Message-ID: <53CE93EC.5090706@st.com>
Date: Tue, 22 Jul 2014 18:40:12 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel@stlinux.com>, <arm@kernel.org>
Subject: Re: [PATCH 2/2] ARM: multi_v7_defconfig: Enable MiPHY365x - ST's
 Generic (SATA & PCIe) PHY
References: <1406021985-8763-1-git-send-email-lee.jones@linaro.org> <1406021985-8763-2-git-send-email-lee.jones@linaro.org> <20140722160630.GA31092@quad.lixom.net> <53CE8E14.9020206@st.com> <20140722161732.GB31092@quad.lixom.net>
In-Reply-To: <20140722161732.GB31092@quad.lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-22_06:2014-07-22,2014-07-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/22/2014 06:17 PM, Olof Johansson wrote:
> On Tue, Jul 22, 2014 at 06:15:16PM +0200, Maxime Coquelin wrote:
>> Hi Olof,
>>
>> On 07/22/2014 06:06 PM, Olof Johansson wrote:
>>> On Tue, Jul 22, 2014 at 10:39:45AM +0100, Lee Jones wrote:
>>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>
>>> Appled both. In the future, feel free to batch them up in one commit,
>>> no need to keep them separate since they're related.
>>
>> I added both to the pull request for defconfig I sent this afternoon.
>> Not an issue?
>
> Yes, that's an issue.
>
> If you comment on a patch you apply, then others will know that you have picked
> it up.

Oops... I usually reply to notify when I pick a patch, but I missed for 
this one.

Sorry for that.

Maxime
>
> I've dropped the versions I applied now so that we don't get duplicate commits
> when I merge your branch.
>
>
> -Olof
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaFYPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:09:57 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:48598 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756481AbaFYPJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:09:56 -0400
Message-ID: <53AAE603.500@st.com>
Date: Wed, 25 Jun 2014 17:08:51 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <olof@lixom.net>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>
Subject: Re: [PATCH] ARM: STi: DT: STiH41x: Convert all uppercase non-defines
 to lowercase
References: <1401195188-23677-1-git-send-email-lee.jones@linaro.org> <20140625145354.GK13518@lee--X1>
In-Reply-To: <20140625145354.GK13518@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-25_04:2014-06-25,2014-06-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/25/2014 04:53 PM, Lee Jones wrote:
>> Suggested-by: Olof Johansson <olof@lixom.net>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  arch/arm/boot/dts/stih415-pinctrl.dtsi   | 340 +++++++++++++++---------------
>>  arch/arm/boot/dts/stih416-b2020-revE.dts |   6 +-
>>  arch/arm/boot/dts/stih416-pinctrl.dtsi   | 342 +++++++++++++++----------------
>>  arch/arm/boot/dts/stih41x-b2000.dtsi     |   6 +-
>>  arch/arm/boot/dts/stih41x-b2020.dtsi     |   6 +-
>>  5 files changed, 350 insertions(+), 350 deletions(-)
> 
> What happened to this Maxime?
> 
> It was Acked by Olof, then died.  Did it slip through the net?
> 

You sent it to the ML after my last pull request for v3.16.
I think to take it for v3.17, but maybe you think it can go in next v3.16 rc?
If so, maybe Arnd or Olof can pick it directly, since we only have this single
patch for v3.16 fixes currently?

Anyway, you will have to rebase it I think, since stih416-b2020-revE.dts has
been renamed to stih416-b2020e.dts.

Don't hesitate to add my:
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Regards,
Maxime


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaGDLkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:40:04 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52012 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbaGDLkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:40:02 -0400
Message-ID: <53B69269.2000609@st.com>
Date: Fri, 4 Jul 2014 13:39:21 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>, Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <patrice.chotard@st.com>,
        <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] STiH407 reset controller support
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>	 <1404317194.4109.13.camel@paszta.hi.pengutronix.de>	 <20140702165924.GB17665@lee--X1> <53B50EFD.2070007@st.com>	 <1404379248.18039.31.camel@paszta.hi.pengutronix.de>	 <20140703094001.GB32208@lee--X1> <1404394341.18039.35.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1404394341.18039.35.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-04_03:2014-07-04,2014-07-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 07/03/2014 03:32 PM, Philipp Zabel wrote:
> Hi Maxime,
> 
> Am Donnerstag, den 03.07.2014, 10:40 +0100 schrieb Lee Jones:
>> On Thu, 03 Jul 2014, Philipp Zabel wrote:
>>> Patch 4 depends on patch 1 for the header. My tree is still empty, how
>>> about I take the first two, and you merge that branch and then take 3
>>> and 4 on top?
>>
>> That approach sounds reasonable.  Once you've applied the patches can
>> you tag the branch and provide Maxime with a pull-request please
>> Philipp?
> 
> The following changes since commit
> 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>    Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>    git://git.pengutronix.de/git/pza/linux.git tags/reset-for-sti-3.17
> 
> for you to fetch changes up to d29d2a38d1c1b21730487e991183ffe7e16e1ef5:
> 
>    reset: sti: Document sti-picophyreset controllers bindings.
> (2014-07-03 14:58:22 +0200)
> 
> ----------------------------------------------------------------
> STiH407 reset controller support
> 
> ----------------------------------------------------------------
> Peter Griffin (2):
>        reset: stih407: Add softreset, powerdown and picophy controllers
>        reset: sti: Document sti-picophyreset controllers bindings.
> 
>   .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
>   drivers/reset/sti/Kconfig                          |   4 +
>   drivers/reset/sti/Makefile                         |   1 +
>   drivers/reset/sti/reset-stih407.c                  | 158
> +++++++++++++++++++++
>   .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
>   5 files changed, 266 insertions(+)
>   create mode 100644
> Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
>   create mode 100644 drivers/reset/sti/reset-stih407.c
>   create mode 100644
> include/dt-bindings/reset-controller/stih407-resets.h

Merged into sti-dt-for-v3.17-1.

Thanks for you help!
Maxime

> 
> regards
> Philipp
> 

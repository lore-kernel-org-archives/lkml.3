Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaCLP1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:27:45 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39093 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754988AbaCLP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:27:43 -0400
Message-ID: <53207CA2.4090309@st.com>
Date: Wed, 12 Mar 2014 16:26:26 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v4 0/6] Add STiH407 SoC and reference board support
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com> <CACRpkdboBkzcJC35-BNvVYmS_t9Cd204AVz4rZasKtNJp0yE4g@mail.gmail.com>
In-Reply-To: <CACRpkdboBkzcJC35-BNvVYmS_t9Cd204AVz4rZasKtNJp0yE4g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-12_06:2014-03-12,2014-03-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 03/12/2014 03:20 PM, Linus Walleij wrote:
> On Wed, Mar 12, 2014 at 9:50 AM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:
>
>> This series adds basic support to the STMicroelectronics STiH407 SoC and its
>> B2120 reference board. The STiH407 is a dual-core ARM Cortex-A9 CPU aimed at
>> STB market.
>>
>> Changes since v3:
>
> I've applied the pinctrl changes to the pinctrl tree, please push all the
> DTS[i] changes through ARM SoC.
As mentioned in the cover-letter, the DTS changes are based on arm_soc's 
for-next branch.

Do you mean I should send a pull request for these three patches?


>
> There is no need to keep DTS and subsystem changes in sync as
> the DTS'es are supposed to be maintained in separation in the
> future anyway.
>

Understood.

Thanks,
Maxime
> Yours,
> Linus Walleij
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaGHH2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:28:33 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:60523 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbaGHH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:28:32 -0400
Message-ID: <53BB9D71.3060203@st.com>
Date: Tue, 8 Jul 2014 09:27:45 +0200
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>, Maxime Coquelin <maxime.coquelin@st.com>
Subject: Re: [PATCH] pinctrl: st: add IRQCHIP_SKIP_SET_WAKE flag
References: <1403711344-17335-1-git-send-email-patrice.chotard@st.com> <CACRpkdY64C0PNEK+E_AVhhxvJMXOiesFHOcvFpRpoTrfb0dtMw@mail.gmail.com>
In-Reply-To: <CACRpkdY64C0PNEK+E_AVhhxvJMXOiesFHOcvFpRpoTrfb0dtMw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-08_03:2014-07-07,2014-07-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07/07/2014 05:32 PM, Linus Walleij wrote:
> On Wed, Jun 25, 2014 at 5:49 PM, Patrice CHOTARD <patrice.chotard@st.com> wrote:
>
>> From: David PARIS <david.paris@st.com>
>>
>> no .irq_set_wake API is available for pinctrl-st driver.
>> Add the IRQCHIP_SKIP_SET_WAKE flag to inform irq handler
>> not to call this API.
>>
>> Signed-off-by: David Paris <david.paris@st.com>
> Patch applied - had to rebase it, strangely the struct is different in
> my tree (check that you're in sync).

My bad, you are right, i haven't forgotten to rebase on top of your tree.

Sorry Linus

Patrice
>
> Yours,
> Linus Walleij


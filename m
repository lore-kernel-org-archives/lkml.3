Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaCNKPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:15:47 -0400
Received: from mx08-00178001.pphosted.com ([62.209.51.94]:48457 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbaCNKPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:15:45 -0400
X-Greylist: delayed 1300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2014 06:15:45 EDT
Message-ID: <5322D009.3090000@st.com>
Date: Fri, 14 Mar 2014 09:46:49 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Coquelin <maxime.coquelin@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joe Perches <joe@perches.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v4 4/6] pinctrl: st: Use ARRAY_SIZE instead of raw value
 for number of delays
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>	<1394614210-15698-5-git-send-email-maxime.coquelin@st.com>	<1394634313.28839.57.camel@joe-AO722> <CACRpkda0Z15zC=d8xe+KyHqgmTCHbnUjL14fBmtscpR-2kHtFQ@mail.gmail.com> <5322CF87.5000301@st.com>
In-Reply-To: <5322CF87.5000301@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-14_04:2014-03-14,2014-03-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/14 09:44, Maxime Coquelin wrote:
>>>
>>> drivers/pinctrl/pinctrl-st.c-   unsigned int    *input_delays;
>>> drivers/pinctrl/pinctrl-st.c-   unsigned int    *output_delays;
>>>
>>> It may be better to change these to const unsigned int *
>>> and change
>>>
>>> static unsigned int stih416_delays[] = {
>>>
>>> to static const
>>
>> Good point. Patches accepted :-)
> 
> Sorry Joe, I forgot to reply.
> 
> I added this to my todo list.
> I will provide the change before end of next week.
> 
Thanks Maxime for taking care of this...

--srini
> Thanks,
> Maxime


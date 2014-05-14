Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaENKCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:02:17 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:46185 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbaENKCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:02:14 -0400
Message-ID: <53733ECD.7090708@st.com>
Date: Wed, 14 May 2014 12:00:45 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        olof Johansson <olof@lixom.net>, <devicetree@vger.kernel.org>,
        <kernel@stlinux.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        <linux-input@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: Re: [STLinux Kernel] [PATCH v4 2/7] driver: reset: sti: add keyscan
 for stih415
References: <1397228856-9218-1-git-send-email-gabriel.fernandez@linaro.org>	 <1397228856-9218-3-git-send-email-gabriel.fernandez@linaro.org>	 <53732EAB.1050709@st.com> <1400058953.13056.2.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1400058953.13056.2.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-14_03:2014-05-13,2014-05-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Philipp.

On 05/14/2014 11:15 AM, Philipp Zabel wrote:
> Hi Maxime,
>
> Am Mittwoch, den 14.05.2014, 10:51 +0200 schrieb Maxime Coquelin:
>> Hi Philipp,
>>
>> 	I am preparing the arm_soc pull request for STi platforms.
>>
>> 	In this series, there are DT patches depending on this reset patch
>> (same for patch 3).
>>
>> 	Can I queue theses two reset patches in my pull request for arm_soc to
>> avoid compilation breakage?
>
> Yes, please do. For both of them, feel free to add my
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
>
> best regards
> Philipp
>

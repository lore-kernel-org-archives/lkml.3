Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaDVMTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:19:05 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55291 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204AbaDVMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:18:59 -0400
Message-ID: <53565DBC.6040709@st.com>
Date: Tue, 22 Apr 2014 14:17:00 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
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
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>	<CACRpkdboBkzcJC35-BNvVYmS_t9Cd204AVz4rZasKtNJp0yE4g@mail.gmail.com>	<53207CA2.4090309@st.com> <CACRpkdZ7NpQBnpKLWSMST6fW9ST_tHi6L66jTQ4kh=+ONfjMgg@mail.gmail.com>
In-Reply-To: <CACRpkdZ7NpQBnpKLWSMST6fW9ST_tHi6L66jTQ4kh=+ONfjMgg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-22_04:2014-04-22,2014-04-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd, Olof,

On 03/14/2014 11:14 AM, Linus Walleij wrote:
> On Wed, Mar 12, 2014 at 4:26 PM, Maxime Coquelin <maxime.coquelin@st.com> wrote:
>> On 03/12/2014 03:20 PM, Linus Walleij wrote:
>
>>> I've applied the pinctrl changes to the pinctrl tree, please push all the
>>> DTS[i] changes through ARM SoC.
>>
>> As mentioned in the cover-letter, the DTS changes are based on arm_soc's
>> for-next branch.
>>
>> Do you mean I should send a pull request for these three patches?
>
> You'd have to ask the ARM SoC maintainers, but if it's a few patches
> they can also apply them directly on the target branch.

It looks like the get_maintainer.pl script does not give your names.
Are DT and mach-sti patches good for you?

If so, can I have you Ack?

Thanks,
Maxime

>
> Yours,
> Linus Walleij
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762407Ab3DDPaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:30:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:35781 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761846Ab3DDPaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:30:03 -0400
Message-ID: <515D9C74.5050207@atmel.com>
Date: Thu, 4 Apr 2013 17:29:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <dgilbert@interlog.com>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <tanzilli@acmesystems.it>, <Robert.Nelson@digikey.com>
Subject: Re: [PATCH v2] ARM: at91: add Acme Systems Aria G25 board
References: <1364201369-12047-1-git-send-email-nicolas.ferre@atmel.com> <1364297952-32473-1-git-send-email-nicolas.ferre@atmel.com> <CAOesGMj+etPUMWffx2CiDtbWbB9A5_6QPbkTsmbEqCiBnkhm3A@mail.gmail.com> <515C7E94.6030702@interlog.com>
In-Reply-To: <515C7E94.6030702@interlog.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 09:10 PM, Douglas Gilbert :
> On 13-04-02 02:48 PM, Olof Johansson wrote:
>> Hi,
>>
>> I just saw this since it came in through a pull request
>>
>> On Tue, Mar 26, 2013 at 4:39 AM, Nicolas Ferre
>> <nicolas.ferre@atmel.com> wrote:
>>> From: Douglas Gilbert <dgilbert@interlog.com>
>>>
>>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> ---
>>>   arch/arm/boot/dts/ariag25.dts | 175
>>> ++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 175 insertions(+)
>>>   create mode 100644 arch/arm/boot/dts/ariag25.dts
>>>
>>> diff --git a/arch/arm/boot/dts/ariag25.dts
>>> b/arch/arm/boot/dts/ariag25.dts
>>> new file mode 100644
>>> index 0000000..b43266f
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/ariag25.dts
>>
>> Please prefix the boards with the platform. Most other SoCs already do
>> this, and I see now that some at91 boards haven't been prefixed in the
>> past, but it's a good idea to not add more of them.
>>
>> So, at91-ariag25.dts is a good name in this case.
> 
> That is fine with me. I have changed my working DT
> config file to at91-ariag25.dts and will push that
> out to Robert Nelson soon.
> 
> Also I'm working on a DT version of an existing Acme
> product called the FoxG20 which is based on the
> AT91SAM9G20 SoC. It already has non-DT support inside
> the mainline kernel. I am using at91-foxg20.dts for
> its DT config file.

Yep! Works for me.

Bye,
-- 
Nicolas Ferre

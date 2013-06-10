Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3FJNzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:55:14 -0400
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:44324 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab3FJNzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:55:10 -0400
Message-ID: <51B5DA26.6070707@st.com>
Date: Mon, 10 Jun 2013 14:52:38 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>, Mark Brown <broonie@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 04/11] mfd:stixxxx-syscfg: Add ST System Configuration
 support.
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856147-6552-1-git-send-email-srinivas.kandagatla@st.com> <CACRpkdaW2ALTWCB7Rd8m=aAGQwh3T_dJVncxJn_eXer4X3J6_g@mail.gmail.com>
In-Reply-To: <CACRpkdaW2ALTWCB7Rd8m=aAGQwh3T_dJVncxJn_eXer4X3J6_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/13 14:16, Linus Walleij wrote:
> On Mon, Jun 10, 2013 at 11:22 AM, Srinivas KANDAGATLA
> <srinivas.kandagatla@st.com> wrote:
> 
>> This mfd driver provides higher level inialization routines for various
>> IPs like Ethernet, USB, PCIE, SATA and so on. Also it provides way to
>> get to syscfg registers via standard regmap api which is usefull for
>> drivers like pinctrl.
>>
>> This patch adds support to ST System Configuration registers, which can
>> be configured by the drivers.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> CC: Stuart Menefy <stuart.menefy@st.com>
>> CC: Stephen Gallimore <stephen.gallimore@st.com>
>> CC: Linus Walleij <linus.walleij@linaro.org>
>> CC: Mark Brown <broonie@kernel.org>
> 
> What is this driver doing that drivers/mfd/syscon.c is not already
> doing?
As of now, the driver is very much similar to syscon + some additional
functionality, but we are planning to use this file to add higher level
functions to configure different IPs like ethernet, usb, power, reset
and so on which are very much specific to ST System Configuration Registers.

Thanks,
srini
> 
> I just get the feeling that you're reinventing the wheel here.
> 
> Yours,
> Linus Walleij
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 


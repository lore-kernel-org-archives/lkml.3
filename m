Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422931Ab3FUJWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:22:22 -0400
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:55406 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab3FUJWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:22:20 -0400
Message-ID: <51C41A25.20508@st.com>
Date: Fri, 21 Jun 2013 10:17:25 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Mark Brown <broonie@kernel.org>,
        John Stultz <john.stultz@linaro.org>, Rob Landley <rob@landley.net>,
        linux-serial@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 01/10] serial:st-asc: Add ST ASC driver.
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com> <1371737103-8871-1-git-send-email-srinivas.kandagatla@st.com> <201306202101.11261.arnd@arndb.de>
In-Reply-To: <201306202101.11261.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/13 20:01, Arnd Bergmann wrote:
> On Thursday 20 June 2013, Srinivas KANDAGATLA wrote:
>> This patch adds support to ASC (asynchronous serial controller)
>> driver, which is basically a standard serial driver. This IP is common
>> across all the ST parts for settop box platforms.
>>
>> ASC is embedded in ST COMMS IP block. It supports Rx & Tx functionality.
>> It support all industry standard baud rates.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> CC: Stephen Gallimore <stephen.gallimore@st.com>
>> CC: Stuart Menefy <stuart.menefy@st.com>
>> CC: Arnd Bergmann <arnd@arndb.de>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
>>From my point of view the series is ready for merging in 3.11,
> I only had a few final comments. I would prefer the first three
> patches to go through the respective serial/clocksource/pinctrl
> trees, since there are no direct build dependencies to the
> platform parts.
> 
Thankyou Arnd,

There are no build dependencies on serial/clocksource/pinctrl.

I will re-spin SOC support patches 4-10 for arm-soc inclusion and wait
for comments on serial/clocksource/pinctrl driver v3 patches.


Thanks,
srini

> If there is a reason to take those through arm-soc, I would
> insist on getting Acked-by's from the subsystem maintainers.
> 
> 	Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 


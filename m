Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3FZJWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:22:20 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:49396 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619Ab3FZJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:22:17 -0400
Message-ID: <51CAB18D.1010906@st.com>
Date: Wed, 26 Jun 2013 10:17:01 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v6] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1372152678-29530-1-git-send-email-srinivas.kandagatla@st.com> <96d7573f-0991-4bda-8f4e-d1f36b743f95@VA3EHSMHS021.ehs.local>
In-Reply-To: <96d7573f-0991-4bda-8f4e-d1f36b743f95@VA3EHSMHS021.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments,
On 25/06/13 22:14, Sören Brinkmann wrote:
>> +Example:
>> > +
>> > +	timer@2c000600 {
>> > +		compatible = "arm,cortex-a9-global-timer";
>> > +		reg = <0x2c000600 0x20>;
>> > +		interrupts = <1 13 0xf01>;
>> > +	};
> Isn't a 'clocks' entry missing here?
Yep, I will add it in v7.

Thanks,
srini


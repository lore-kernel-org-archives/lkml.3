Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaBCIfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:35:31 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:49318 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181AbaBCIf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:35:29 -0500
Message-ID: <52EF546D.7070900@st.com>
Date: Mon, 3 Feb 2014 09:33:49 +0100
From: Alexandre Torgue <alexandre.torgue@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        srinivas kandagatla <srinivas.kandagatla@st.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <kernel@stlinux.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        <linux-kernel@vger.kernel.org>, Stuart Menefy <stuart.menefy@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, <maxime.coquelin@st.com>
Subject: Re: [PATCH 1/4] ARM: STi: add stid127 soc support
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <201401301939.08302.arnd@arndb.de> <52EB96BB.6070800@st.com> <201401312115.33731.arnd@arndb.de>
In-Reply-To: <201401312115.33731.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 09:15 PM, Arnd Bergmann wrote:
> On Friday 31 January 2014, srinivas kandagatla wrote:
>
>>> Sorry if I missed the initial review, but can you explain
>>> why this is needed to start with?
>> On ST SoCs the default value for L2 AUX_CTRL register is 0x0, so we  set
>> the way-size explicit here.
> Unfortunately, we keep going back and forth on the L2 cache controller
> setup between "it should work automatically" and "we don't want to
> have configuration data in DT", where my personal opinion is that
> the first one is more important here.
>
> Now, there are a couple of properties that are defined in
> Documentation/devicetree/bindings/arm/l2cc.txt to let some of the
> things get set up automatically already. Can you check which bits
> are missing there, if any? Are they better described as "configuration"
> or "hardware" settings?
Hi Arnd,

Thanks for remarks. I will a have a look on it, but unfortunately not 
before 2 weeks.


Alex.

>
> 	Arnd


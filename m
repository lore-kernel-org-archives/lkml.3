Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3JBN5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:57:33 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:50051 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab3JBN53 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:57:29 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Date: Wed, 2 Oct 2013 15:56:39 +0200
Subject: Re: [PATCH 1/4] i2c: busses: i2c-st: Add ST I2C controller
Thread-Topic: [PATCH 1/4] i2c: busses: i2c-st: Add ST I2C controller
Thread-Index: Ac6/dzepuc+3qlbJRB2MCyUnbfry+w==
Message-ID: <524C2617.5070401@st.com>
References: <1380623952-4252-1-git-send-email-maxime.coquelin@st.com>
 <1380623952-4252-2-git-send-email-maxime.coquelin@st.com>
 <524B346C.8070607@wwwdotorg.org> <524BDB00.3010508@st.com>
 <20131002090257.GA3059@katana> <524BE8FB.40000@st.com>
In-Reply-To: <524BE8FB.40000@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On 10/02/2013 11:35 AM, Maxime Coquelin wrote:
>
> On 10/02/2013 11:02 AM, Wolfram Sang wrote:
>>>>> +Optional properties :
>>>>> +- i2c-min-scl-pulse-width-us : The minimum valid SCL pulse width 
>>>>> that is allowed
>>>>> +  through the deglitch circuit. In units of us.
>>>>> +- i2c-min-sda-pulse-width-us : The minimum valid SDA pulse width 
>>>>> that is allowed
>>>>> +  through the deglitch circuit. In units of us.
>>>> Are those properties specific to this binding, or intended to be
>>>> generic? If specific to this binding, a vendor prefix should be 
>>>> present
>>>> in the property name. If not, you probably want to document the
>>>> properties in some common file.
>>> Ok.
>>> In last revision, I put this properties as specific to this binding.
>>> Wolfram proposed to make this generic, but it looks like this IP is the
>>> only one
>>> needing such properties.
>>>
>>> Wolfram, what would you advise?
>> It might be the only SoC now, but I could imagine that other will have
>> something similar in the future. I am not perfectly sure, though. So, I
>> asked for opinions from DT experts when I suggested those bindings. We
>> could start with vendor specific bindings and generalize them later if
>> similar ones appear. Yet my experience is that old drivers rarely get
>> converted to the new bindings.
> Ok.
> But if I start with vendor specific bindings, we will have to support it
> forever, right?
I would be glad to have your opinion on this.

Since there are no other vendors currently having this feature,
should we put these properties vendor specific?
Or put them generic in case of someone has the same feature in the future?

Thanks,
Maxime


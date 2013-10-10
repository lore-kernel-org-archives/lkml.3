Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3JJNeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:34:46 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:41207 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326Ab3JJNen convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:34:43 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
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
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Date: Thu, 10 Oct 2013 15:33:43 +0200
Subject: Re: [PATCH v4 0/4] Add I2C support to ST SoCs
Thread-Topic: [PATCH v4 0/4] Add I2C support to ST SoCs
Thread-Index: Ac7FvVcWPNmEFKp5RQKOcgLe1Sc+Uw==
Message-ID: <5256ACB7.7050302@st.com>
References: <1381250576-7916-1-git-send-email-maxime.coquelin@st.com>
 <525675B6.4080404@st.com> <20131010100354.GE2638@katana>
In-Reply-To: <20131010100354.GE2638@katana>
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


On 10/10/2013 12:03 PM, Wolfram Sang wrote:
>>> Changes since v3:
>>>     - Switch back to vendor specific DT properties regarding the anti-glitch
>>>       filter configuration, as this IP is the only one having such a filter.
>> Do you agree to keep these properties vendor-specifics?
> My preference is generic bindings. There are no other users right now,
> yet there might be in the future. At least with something similar enough
> that the bindings will apply. Was hoping for some additional input,
> though, but I am not depending on it.
I have to push another revision to change the IRQ flags as reported by 
Stephen G.
I will also revert to generic bindings in this revision.
For their documentation, I will add it as soon as you will have created 
the DT binding documentation of I2C.

Is it okay for you?
>
>> If so, could you take this series for v3.13?
> Sure, if it passes the second review...
For sure!

Regards,
Maxime

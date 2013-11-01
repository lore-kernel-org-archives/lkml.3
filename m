Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3KANBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:01:09 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:44139 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab3KANBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:01:06 -0400
Message-ID: <5273A391.5000302@st.com>
Date: Fri, 1 Nov 2013 12:50:25 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Lucas Stach <l.stach@pengutronix.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>  <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>  <20131016151419.GA14104@ns203013.ovh.net> <525F915D.9020501@st.com>  <525FAEED.7030207@st.com> <20131017141957.GE14104@ns203013.ovh.net>  <525FF498.3060202@st.com> <1382021369.4093.44.camel@weser.hi.pengutronix.de> <5260EFDC.804@st.com> <526E7C8C.8080603@st.com>
In-Reply-To: <526E7C8C.8080603@st.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/13 15:02, Maxime Coquelin wrote:
>>
>> 6> IMHO, the compatible string should be "vendor,<IP-name>-<IP-version>"
>> rather than first SoC.
> I agree.
> In this case, we add support to revision 4 of SSC IP.
Its not the revision its name of the new IP which is SSC4. However  this
driver is also compatible with old SSC IP, so It would be nice to have
something like two compatible strings "st,comms-ssc-i2c" and
"st,comms-ssc4-i2c"

Thanks,
srini
> 
> Is "st,comms-ssc-v4" okay?





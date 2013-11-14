Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3KNRRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:17:05 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:57153 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab3KNRQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:16:53 -0500
Message-ID: <52850555.90304@st.com>
Date: Thu, 14 Nov 2013 18:16:05 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
Cc: <srinivas.kandagatla@st.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        <stephen.gallimore@st.com>, <stuart.menefy@st.com>,
        Lee Jones <lee.jones@linaro.org>, <gabriel.fernandez@st.com>
Subject: Re: [PATCH v6 1/4] i2c: busses: i2c-st: Add ST I2C controller
References: <1383726315-27534-1-git-send-email-maxime.coquelin@st.com> <1383726315-27534-2-git-send-email-maxime.coquelin@st.com> <20131114170026.GA11022@katana>
In-Reply-To: <20131114170026.GA11022@katana>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.19.60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/14/2013 06:00 PM, Wolfram Sang wrote:
> On Wed, Nov 06, 2013 at 09:25:12AM +0100, Maxime COQUELIN wrote:
>> This patch adds support to SSC (Synchronous Serial Controller)
>> I2C driver. This IP also supports SPI protocol, but this is not
>> the aim of this driver.
>>
>> This IP is embedded in all ST SoCs for Set-top box platorms, and
>> supports I2C Standard and Fast modes.
>>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>
> Applied to for-next, thanks!
>

Thanks Wolfram!

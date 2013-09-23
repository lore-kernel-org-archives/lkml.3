Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3IWUz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:55:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3IWUz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:55:56 -0400
Message-ID: <5240AAD6.7050002@wwwdotorg.org>
Date: Mon, 23 Sep 2013 14:55:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
CC: Maxime COQUELIN <maxime.coquelin@st.com>, Wolfram Sang <wsa@the-dreams.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
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
        Olivier CLERGEAUD <olivier.clergeaud@st.com>
Subject: Re: [PATCH 1/4] i2c: busses: i2c-st: Add ST I2C controller
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com> <1379498483-4236-2-git-send-email-maxime.coquelin@st.com> <5239A0ED.6010606@st.com>
In-Reply-To: <5239A0ED.6010606@st.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 06:47 AM, Gabriel FERNANDEZ wrote:
> On 18/09/2013 12:01, Maxime COQUELIN wrote:
>> This patch adds support to SSC (Synchronous Serial Controller)
>> I2C driver. This IP also supports SPI protocol, but this is not
>> the aim of this driver.
>>
>> This IP is embedded in all ST SoCs for Set-top box platorms, and
>> supports I2C Standard and Fast modes.
> ... [entire patch quoted for a one-line comment] ...

Please trim down the patch so you only quote relevant lines. Quoting the
entire patch for a 1-line comment makes people wast time searching for
your reply.

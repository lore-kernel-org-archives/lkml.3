Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaBYLEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:04:11 -0500
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:42417 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaBYLEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:04:08 -0500
Message-ID: <530C76F0.8000909@st.com>
Date: Tue, 25 Feb 2014 10:56:48 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <kernel@stlinux.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stephen.gallimore@st.com>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/6] ARM: STi reset controller support
References: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>					<1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>				<1391592486.11239.4.camel@pizza.hi.pengutronix.de>			 <52F4D76F.8070301@st.com> <5304B849.2080806@st.com>		 <1393237988.3091.14.camel@pizza.hi.pengutronix.de>		 <530B514A.4070209@st.com>	 <1393254982.3091.44.camel@pizza.hi.pengutronix.de>	 <530C5D8C.1080809@st.com> <1393321661.4156.2.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1393321661.4156.2.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou Philipp,
On 25/02/14 09:47, Philipp Zabel wrote:
>> No, the context is lost, the IP needs re-initialization.
> alright then, I'll add them to the queue.
Thats Great..
Can I ask your Ack on these patches so that I can request Arnd/Olof to
take these patches via arm-soc tree.

Hi Arnd/Olof,

I have few more DT patches which depend on the reset controller header
file. Is is possible to take the reset controller patches with Philipp's
Acks via arm-soc tree?

Thanks,
srini

> 
> thanks
> Philipp
> 
> 
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaCGLdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:33:52 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:44942 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbaCGLdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:33:50 -0500
Message-ID: <5319ACF9.4040504@st.com>
Date: Fri, 7 Mar 2014 11:26:49 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Coquelin <maxime.coquelin@st.com>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>
Cc: <lee.jones@linaro.org>
Subject: Re: [PATCH v2 3/5] pinctrl: st: Enhance the controller to manage
 unavailable registers
References: <1394185272-26054-1-git-send-email-maxime.coquelin@st.com> <1394185272-26054-4-git-send-email-maxime.coquelin@st.com> <5319A263.6020201@st.com> <5319AD5C.7050301@st.com>
In-Reply-To: <5319AD5C.7050301@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/14 11:28, Maxime Coquelin wrote:
>>
> 
> Problem is that "oe" and "pu" takes -1 in that patch, and these values
> will be passed directly to devm_regmap_field_alloc without any check.
> 
> I propose to apply this patch before "pinctrl: st: add pinctrl support
> for the STiH407 SoC", and move stih407_flashdata as you recommend.
> 
> Is it fine for you?
Am OK with re-ordering, This will also be good for git bisect... :-)


Thanks,
srini

> 
> Thanks for the review,
> Maxime


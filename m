Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbaJULuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:50:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55452 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaJULuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:50:04 -0400
Message-ID: <5446482D.2060909@ti.com>
Date: Tue, 21 Oct 2014 17:19:01 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        <Valdis.Kletnieks@vt.edu>
CC: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>, Harsh Gupta <harsh.gupta@st.com>
Subject: Re: [PATCH v3 6/8] phy: miphy28lp: Add SSC support for PCIE
References: <1411721657-9924-1-git-send-email-gabriel.fernandez@linaro.org>	<1411721657-9924-7-git-send-email-gabriel.fernandez@linaro.org>	<15685.1412018368@turing-police.cc.vt.edu> <CAG374jBJcX00S4nSugWXaUxAQV3Bwp+OxY0c2GJ-+rskzDzpGw@mail.gmail.com>
In-Reply-To: <CAG374jBJcX00S4nSugWXaUxAQV3Bwp+OxY0c2GJ-+rskzDzpGw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 13 October 2014 01:46 PM, Gabriel Fernandez wrote:
> Hi Valdis,
> Thanks for your remark.
> 
> Concerning multiple writing in MIPHY_PLL_SBR_1, the writing of the
> first 0 it's to be sure there is no previous request.
> Then we take account new setting by writing 0x02.
> And then we make it 0 to make sure there is no other pending requests.
> 
> I added comments and macro to be more clear (see the code below).
> 
> 
> Hi Kishon,
> 
> Do you want a new patch set (v4),  or i wait other remarks from you ?

Apart from my comment below and for adding a common dt header file, rest of it
looks fine.
> 
> 
>     for (val = 0; val < 2; val++) {

What is "2" here? Lets add a macro for it.

Thanks
Kishon

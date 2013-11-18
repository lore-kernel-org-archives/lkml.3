Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3KRLim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:38:42 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:42614 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab3KRLib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:38:31 -0500
Message-ID: <5289FBA5.6070102@st.com>
Date: Mon, 18 Nov 2013 11:36:05 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        <stephen.gallimore@st.com>, <stuart.menefy@st.com>,
        Lee Jones <lee.jones@linaro.org>, <gabriel.fernandez@st.com>
Subject: Re: [PATCH v6 3/4] ARM: STi: Supply I2C configuration to STiH415
 SoC
References: <1383726315-27534-1-git-send-email-maxime.coquelin@st.com> <1383726315-27534-4-git-send-email-maxime.coquelin@st.com>
In-Reply-To: <1383726315-27534-4-git-send-email-maxime.coquelin@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/13 08:25, Maxime COQUELIN wrote:
> This patch supplies I2C configuration to STiH415 SoC.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  arch/arm/boot/dts/stih415-pinctrl.dtsi |   36 ++++++++++++++++++++++
>  arch/arm/boot/dts/stih415.dtsi         |   53 ++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+)
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Thanks,
srini

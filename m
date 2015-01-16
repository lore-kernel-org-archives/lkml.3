Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbAPKnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:43:22 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:43047 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbAPKnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:43:20 -0500
Date: Fri, 16 Jan 2015 10:43:15 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        lee.jones@linaro.org
Subject: Re: [PATCH 0/3] Add STiH418 SoC and reference board support
Message-ID: <20150116104315.GA5102@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1420816306-11305-1-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420816306-11305-1-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

> This series adds basic support to the STMicroelectronics STiH407 SoC and its
> B2199 reference board. The STiH418 is a quad-core ARM Cortex-A9 CPU aimed at
> UHD STB market.
> 
> Maxime Coquelin (3):
>   ARM: STi: Add STiH418 SoC support
>   ARM: dts: Add STiH418 SoC support
>   ARM: dts: STiH418: Add B2199 board support

Looks good to me. For the series: -

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter

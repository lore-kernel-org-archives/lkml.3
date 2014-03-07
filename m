Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaCGDLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:11:47 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:60018 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaCGDLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:11:45 -0500
MIME-Version: 1.0
In-Reply-To: <1393589841-6634-1-git-send-email-maxime.coquelin@st.com>
References: <1393589841-6634-1-git-send-email-maxime.coquelin@st.com>
Date: Fri, 7 Mar 2014 11:11:45 +0800
Message-ID: <CACRpkdbztgbWn3kmm4gv6OLcX+bPnyK5BCt0SJJcWo+iyGsWvA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add STiH407 SoC and reference board support
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 8:17 PM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:

> This series adds basic support to the STMicroelectronics STiH407 SoC and its
> B2120 reference board. The STiH407 is a dual-core ARM Cortex-A9 CPU aimed at
> STB market.
>
> Giuseppe Cavallaro (2):
>   ARM: STi: add pinctrl support for the STiH407 SoC
>   pinctrl: st: Enhance the controller to manage unavailable registers
>
> Maxime Coquelin (3):
>   ARM: STi: Add STiH407 SoC support
>   ARM: dts: Add STiH407 SoC support
>   ARM: dts: STiH407: Add B2120 board support

So I'd like to take the pinctrl patch through my tree and the rest through
ARM SoC but it seems it does not apply :-/

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaCJQQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:16:21 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:63162 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaCJQQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:16:18 -0400
Date: Mon, 10 Mar 2014 16:16:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: Re: [PATCH v3 4/5] ARM: dts: Add STiH407 SoC support
Message-ID: <20140310161611.GF13661@lee--X1>
References: <1394203251-25361-1-git-send-email-maxime.coquelin@st.com>
 <1394203251-25361-5-git-send-email-maxime.coquelin@st.com>
 <20140310122830.GT14976@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140310122830.GT14976@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		CLK_EXT2F_A9: clockgenC0@13 {
> 
> s/@/@0x

<snip>

> > +			PIO0: gpio@09610000 {
> 
> s/@/@0x
> 
> I won't mention this particular point again, but it needs to be
> propagated throughout the patch.

Whoops, I'm actually completely wrong on this point! There is to be
_no_ 0x prefix prior to the address, as per the following commits: 

`git log --author="Lee Jones" --grep="0x" mainline/master -- arch/arm/boot/dts/`

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

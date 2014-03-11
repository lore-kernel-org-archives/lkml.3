Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaCKLMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:12:45 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52701 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaCKLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:12:41 -0400
Date: Tue, 11 Mar 2014 11:12:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
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
Subject: Re: [PATCH v3 2/5] pinctrl: st: Enhance the controller to manage
 unavailable registers
Message-ID: <20140311111234.GA21216@lee--X1>
References: <1394203251-25361-1-git-send-email-maxime.coquelin@st.com>
 <1394203251-25361-3-git-send-email-maxime.coquelin@st.com>
 <20140310091707.GD14976@lee--X1>
 <531EC6C0.4080202@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531EC6C0.4080202@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> >>
> >>This patch adds a new logic inside the st pinctrl to manage
> >>an unsupported scenario: some sysconfig are not available!
> >>
> >>This is the case of STiH407 where, although documented, the
> >>following registers from SYSCFG_FLASH have been removed from the SoC.
> >>
> >>SYSTEM_CONFIG3040
> >>    Output Enable pad control for all PIO Alternate Functions
> >>and
> >>SYSTEM_ CONFIG3050
> >>    Pull Up pad control for all PIO Alternate Functions
> >>
> >>Without managing this condition an imprecise external abort
> >>will be detect.
> >>
> >>To do this the patch also reviews the st_parse_syscfgs
> >>and other routines to manipulate the registers only if
> >>actually available.
> >>In any case, for example the st_parse_syscfgs detected
> >>an error condition but no action was made in the
> >>st_pctl_probe_dt.
> >>
> >>Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> >>Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

No problem with any of your comments. Once the fixups have been made,
feel free to apply my:

  Acked-by: Lee Jones <lee.jones@linaro.org>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

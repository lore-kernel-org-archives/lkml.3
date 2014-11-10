Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaKJK46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:56:58 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43606 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaKJK44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:56:56 -0500
Date: Mon, 10 Nov 2014 10:56:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org
Subject: Re: ARM: sti: SOC_STIH407 and STIH407_RESET?
Message-ID: <20141110105649.GW21424@x1>
References: <1415614934.4862.22.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415614934.4862.22.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Paul Bolle wrote:
> Your commit c27321141915 ("ARM: sti: Add STiH407 Kconfig entry to select
> STIH407_RESET") was included in today's linux-next (ie, next-20141110).
> It adds a Kconfig entry for SOC_STIH407. That entry selects
> STIH407_RESET.
> 
> There's no Kconfig symbol STIH407_RESET. And there's nothing in
> next-20141110 that cares about SOC_STIH407. So this entry is currently a
> nop.

You're right, thanks for your diligence.

> I assume that there are one or more patches queued that make this entry
> do something. Is that correct?

That is also true.  Patch is en route.

It should be coming through the reset tree and arm-soc.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

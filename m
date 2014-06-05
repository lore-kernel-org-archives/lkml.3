Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaFEIRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:17:49 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:58494 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFEIRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:17:46 -0400
Date: Thu, 5 Jun 2014 09:17:42 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-doc@vger.kernel.org, Olivier Bideau <olivier.bideau@st.com>,
        linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [STLinux Kernel] [PATCH RESEND 03/12] drivers: clk: st: STiH407:
 Support for Flexgen Clocks
Message-ID: <20140605081742.GC3865@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
 <1401892320-18211-4-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401892320-18211-4-git-send-email-gabriel.fernandez@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2014, Gabriel FERNANDEZ wrote:

> This patch is the Flexgen implementation reusing as much as possible
> of Common Clock Framework functions.
> 
> The idea is to have an instance of "struct flexgen" per output clock.
> It represents the clock cross bar (by a mux element), and the pre and final dividers
> (using dividers and gates elements).
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>  drivers/clk/st/Makefile      |   2 +-
>  drivers/clk/st/clk-flexgen.c | 332 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 333 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/st/clk-flexgen.c

Acked-by: Peter Griffin <peter.griffin@linaro.org>

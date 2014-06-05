Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaFEIsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:48:35 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:49957 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaFEIsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:48:32 -0400
Date: Thu, 5 Jun 2014 09:48:28 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [STLinux Kernel] [PATCH RESEND 01/12] clk: st: Update ST clock
 binding documentation
Message-ID: <20140605084828.GD3865@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
 <1401892320-18211-2-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401892320-18211-2-git-send-email-gabriel.fernandez@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2014, Gabriel FERNANDEZ wrote:

> This patch adds new compatibilities to support STiH407 SoC.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>  .../devicetree/bindings/clock/st/st,clkgen-mux.txt   |  2 +-
>  .../devicetree/bindings/clock/st/st,clkgen-pll.txt   |  5 ++++-
>  .../devicetree/bindings/clock/st/st,clkgen.txt       | 20 ++++++++++++++++----
>  .../devicetree/bindings/clock/st/st,quadfs.txt       |  3 +++
>  4 files changed, 24 insertions(+), 6 deletions(-)

Acked-by: Peter Griffin <peter.griffin@st.com>

Regards,

Peter

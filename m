Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaFEL6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:58:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41082 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaFEL6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:58:03 -0400
Date: Thu, 5 Jun 2014 12:57:58 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [STLinux Kernel] [PATCH RESEND 12/12] drivers: clk: st: Use
 round to closest divider flag
Message-ID: <20140605115758.GB2294@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
 <1401892320-18211-13-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401892320-18211-13-git-send-email-gabriel.fernandez@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2014, Gabriel FERNANDEZ wrote:

> This patch uses CLK_DIVIDER_ROUND_CLOSEST flag to specify
> the divider has to round to closest div.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> ---
>  drivers/clk/st/clkgen-mux.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Acked-by: Peter Griffin <peter.griffin@linaro.org>

Regards,

Peter

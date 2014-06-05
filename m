Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaFELca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:32:30 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62952 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaFELc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:32:28 -0400
Date: Thu, 5 Jun 2014 12:32:23 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-doc@vger.kernel.org, Olivier Bideau <olivier.bideau@st.com>,
        linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [STLinux Kernel] [PATCH RESEND 08/12] drivers: clk: st: STiH407:
 Support for clockgenC0
Message-ID: <20140605113223.GC11244@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
 <1401892320-18211-9-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401892320-18211-9-git-send-email-gabriel.fernandez@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2014, Gabriel FERNANDEZ wrote:

> The patch added support for DT registration of ClockGenC0
> It includes 2 c32 type PLL and a 660 Quadfs.
> 
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
> ---
>  drivers/clk/st/clkgen-fsyn.c | 47 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/st/clkgen-pll.c  | 32 ++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)

Acked-by: Peter Griffin <peter.griffin@linaro.org>

Regards,

Peter

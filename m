Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaFEJAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:00:16 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48953 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaFEJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:00:14 -0400
Date: Thu, 5 Jun 2014 10:00:09 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-doc@vger.kernel.org, Olivier Bideau <olivier.bideau@st.com>,
        linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [STLinux Kernel] [PATCH RESEND 04/12] drivers: clk: st: STiH407:
 Support for A9 MUX Clocks
Message-ID: <20140605090009.GA9977@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
 <1401892320-18211-5-git-send-email-gabriel.fernandez@linaro.org>
 <20140605085535.GE3865@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605085535.GE3865@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014, Peter Griffin wrote:

> On Wed, 04 Jun 2014, Gabriel FERNANDEZ wrote:
> 
> > The patch supports the A9-mux clocks used by ClockGenA9
> > 
> > Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> > Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
> > ---
> >  drivers/clk/st/clkgen-mux.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> 
> Acked-by: Peter Griffin <peter.griffin@st.com>

Sorry old habits die hard, that should have been

Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaIHKbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:31:44 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58236 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaIHKbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:31:42 -0400
Date: Mon, 8 Sep 2014 11:31:37 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/4] phy: phy-stih41x-usb: Add usb phy support for
 STiH41x SoCs.
Message-ID: <20140908103137.GA17057@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1410168638-11072-1-git-send-email-peter.griffin@linaro.org>
 <1410168638-11072-2-git-send-email-peter.griffin@linaro.org>
 <540D793E.9050301@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540D793E.9050301@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

> > +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> > +	if (IS_ERR(phy_provider))
> > +		return PTR_ERR(phy_provider);
> 
> registering phy provider multiple times..

Doh. Sorry for the noise, will send a v4 shortly.

regards,

Peter.

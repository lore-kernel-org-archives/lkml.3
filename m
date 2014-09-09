Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaIIK1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:05 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47814 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbaIIK1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:00 -0400
Date: Tue, 9 Sep 2014 11:26:55 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/4] phy: phy-stih407-usb: Add usb picoPHY driver
 found on stih407 SoC family
Message-ID: <20140909102655.GA8544@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1410253218-18318-1-git-send-email-peter.griffin@linaro.org>
 <1410253218-18318-2-git-send-email-peter.griffin@linaro.org>
 <2894228.eRmxgHsWbh@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2894228.eRmxgHsWbh@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for reviewing :-)

> > +	phy = devm_phy_create(dev, NULL, match->data, NULL);
> > +	if (IS_ERR(phy)) {
> > +		dev_err(dev, "failed to create Display Port PHY\n");
> > +		return PTR_ERR(phy);
> > +	}
> > +
> 
> There is only one entry in the match table, so it always points to
> stih407_usb2_picophy_data. Do you have plans to add another set of
> operations soon?

Nope.

> If not, just remove the .data pointer and hardcode the operations
> in the devm_phy_create call.

I've done as you suggest in v3 which I will send shortly.

regards,

Peter.

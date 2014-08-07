Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaHGOQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:16:39 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42170 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbaHGOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:16:36 -0400
Date: Thu, 7 Aug 2014 15:16:31 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/6] usb: host: usb-st-common: Add common code
 required by ohci-st and ehci-st
Message-ID: <20140807141631.GC12137@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
 <1407344589-24863-2-git-send-email-peter.griffin@linaro.org>
 <201408062259.10697.arnd@arndb.de>
 <20140807141457.GB12137@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807141457.GB12137@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> > > (priv->rst);
> > > +		if (ret)
> > > +			goto err_assert_power;
> > > +	}
> > 
> > I wouldn't make these optional, just call the functions
> > unconditionally and fail the probe function if they are
> > not available.

Also I've also done as you suggest and made
these non optional in V4.

regards,

Peter.

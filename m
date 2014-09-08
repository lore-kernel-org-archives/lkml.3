Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaIHPxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:53:42 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63237 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaIHPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:53:40 -0400
Date: Mon, 8 Sep 2014 16:53:31 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 0/3]  Add picoPHY usb phy driver found on stih407 family
 SoC's
Message-ID: <20140908155331.GA7620@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org>
 <540DC9F6.8090306@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DC9F6.8090306@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

> On Wednesday 03 September 2014 03:57 PM, Peter Griffin wrote:
> > This series adds support for the picoPHY usb phy which is used by the usb2
> > and usb3 host controllers when controlling usb2/1.1 devices. It is found on
> > stih407 family SoC's from the consumer electronics devision of STMicroelectronics.
> 
> So miphy28lp is the PHY controller for USB3 device controller and picoPHY is
> the PHY controller for USB3 host controller?

No, miphy28lp is the usb3 phy and picoPHY is the usb2 phy.

With a usb2 host controller only picoPHY is used. With the usb3 host controller both usb2 and usb3 phys
are used depending on what type of device is plugged in.

Hope that clarifies things,

regards,

Peter.

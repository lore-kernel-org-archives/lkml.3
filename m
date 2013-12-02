Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3LBNUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:20:21 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64688 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3LBNUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:20:20 -0500
Date: Mon, 2 Dec 2013 13:20:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: srinivas kandagatla <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org, angus.clark@st.com
Subject: Re: [PATCH v3 36/36] ARM: STi: Add support for the FSM Serial Flash
 Controller
Message-ID: <20131202132013.GF31626@lee--X1>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-37-git-send-email-lee.jones@linaro.org>
 <529C858B.1040601@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529C858B.1040601@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		/* FSM */
> > +		spifsm: spifsm@fe902000{
> > +		        compatible         = "st,spi-fsm", "simple-bus";
> "simple-bus" is redundant here.

Yes I agree, good spot.

I removed it from the Documentation, but missed this one.

If I remove it, can I add your Ack for the remainder of the patch?

> > +		        reg                =  <0xfe902000 0x1000>;
> > +		        reg-names          = "spi-fsm";
> > +		        pinctrl-0          = <&pinctrl_fsm>;
> > +
> > +			st,syscfg	   = <&syscfg_rear>;
> > +		        st,boot-device-reg = <0x958>;
> > +		        st,boot-device-spi = <0x1a>;
> > +
> > +		        status = "okay";
> > +		};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

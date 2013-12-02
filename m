Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3LBNKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:10:34 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:42056 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556Ab3LBNKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:10:31 -0500
Message-ID: <529C858B.1040601@st.com>
Date: Mon, 2 Dec 2013 13:05:15 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dwmw2@infradead.org>, <linus.walleij@linaro.org>,
        <linux-mtd@lists.infradead.org>, <angus.clark@st.com>
Subject: Re: [PATCH v3 36/36] ARM: STi: Add support for the FSM Serial Flash
 Controller
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org> <1385727565-25794-37-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1385727565-25794-37-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,
On 29/11/13 12:19, Lee Jones wrote:
> +		/* FSM */
> +		spifsm: spifsm@fe902000{
> +		        compatible         = "st,spi-fsm", "simple-bus";
"simple-bus" is redundant here.

> +		        reg                =  <0xfe902000 0x1000>;
> +		        reg-names          = "spi-fsm";
> +		        pinctrl-0          = <&pinctrl_fsm>;
> +
> +			st,syscfg	   = <&syscfg_rear>;
> +		        st,boot-device-reg = <0x958>;
> +		        st,boot-device-spi = <0x1a>;
> +
> +		        status = "okay";
> +		};


thanks,
srini

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbaKMKWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:22:25 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34685 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaKMKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:22:23 -0500
Date: Thu, 13 Nov 2014 10:22:18 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 07/13] ARM: STi: DT: STiH407: Add usb2 picophy dt nodes
Message-ID: <20141113102218.GA25886@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-8-git-send-email-peter.griffin@linaro.org>
 <20141110101131.GP21424@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110101131.GP21424@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thanks for reviewing.

On Mon, 10 Nov 2014, Lee Jones wrote:
> > +			reg =	<0xf8 0x04>,	/* syscfg 5062 */
> > +				<0xf4 0x04>;    /* syscfg 5061 */
> 
> Are there really only 2 32bit registers to control this h/w?

Yes

> 
> > +			reg-names =	"param",
> > +					"ctrl";
> 
> Superflous indentation after 'reg = ' and 'reg-names = '.

Fixed in v2.

> > +			st,syscfg = <&syscfg_core>;
> > +			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
> > +				 <&picophyreset STIH407_PICOPHY0_RESET>;
> > +			reset-names = "global",
> > +				      "port";
> 
> May as well put these on the same line.

Fixed in v2.

regards,

Peter.

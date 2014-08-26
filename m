Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbaHZIhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:37:04 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:57769 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaHZIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:36:58 -0400
Date: Tue, 26 Aug 2014 09:36:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v5 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140826083650.GE9574@lee--X1>
References: <1408973516-21395-1-git-send-email-zyw@rock-chips.com>
 <CAD=FV=Wz1yssGvB05ExPaYxsiizcPRYrfP9OWE+HdoSDKVc_Tw@mail.gmail.com>
 <53FBF6EB.1080002@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53FBF6EB.1080002@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Chris Zhong wrote:
> On 08/26/2014 04:44 AM, Doug Anderson wrote:
> >On Mon, Aug 25, 2014 at 6:31 AM, Chris Zhong <zyw@rock-chips.com> wrote:

[...]

> >You need a Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
> 
> Done

[...]

> >I think Lee's "Grim" comment here was that prefixing globals with "g_"
> >is not consistent with the Linux coding style.  Just remove the "g_".
> 
> Done

[...]

> >{ RK808_BUCK3_CONFIG_REG, BUCK_ILMIN_MASK,  BUCK_ILMIN_150MA },
> >
> >instead of:
> >
> >{RK808_BUCK3_CONFIG_REG, BUCK_ILMIN_MASK,  BUCK_ILMIN_150MA},
> 
> Done

[...]

> >nit: add spacing so that VB_LO_SEL_3500MV lines up under VB_LO_ACT
> 
> Done

[...]

> >I think Lee wanted the above to be:
> >
> >        { "rk808", },
> 
> Done

[...]

> >I think Lee wanted you to remove ".owner = THIS_MODULE"
> 
> Done

[...]

You've just spammed 10(00)'s of people with an email that contains
zero useful content.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

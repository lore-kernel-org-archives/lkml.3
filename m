Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaEUWwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:52:35 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62637 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753255AbaEUWwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:52:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Bd4ZRbscL0G1eYUJifogP
Date: Wed, 21 May 2014 15:52:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: FanWu <fwu@marvell.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Chao Xie <cxie4@marvell.com>,
        Yilu Mao <ylmao@marvell.com>, Ning Jiang <njiang1@marvell.com>,
        Xiaofan Tian <tianxf@marvell.com>, Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH] pinctrl: add params in disable_setting for different
 usage
Message-ID: <20140521225226.GE14520@atomide.com>
References: <1400032874-3423-1-git-send-email-fwu@marvell.com>
 <CACRpkdaTX_SyWXrpysaJGLee+SnLPxdQQkvE-5Xy+OmHCcseVw@mail.gmail.com>
 <53766CA7.8000507@wwwdotorg.org>
 <53797279.1010109@marvell.com>
 <537A6FB5.80905@wwwdotorg.org>
 <537AC661.7010400@marvell.com>
 <537BA20A.3080109@wwwdotorg.org>
 <537C4605.2090203@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537C4605.2090203@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* FanWu <fwu@marvell.com> [140520 23:23]:
> To remove the HW disable function in pinmux_disable_setting is no effect for
> our SoC platform. I am just not sure whether it has effect for other
> platform just as I described before.
> If there is no vendor using the HW disabling operation, I also agree to
> remove this. :)
> 
> Could you please give your suggestion about this topic ?

I agree with Stephen that we should remove the disable as at least
for the SoCs that I've dealt with there is no disable setting. The
closest I can think of is the safe mode that some omaps have, but
that too is just one mode. And disabling input logic can be done
separately from the mux mode typically.

Regards,

Tony

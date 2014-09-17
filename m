Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbaIQVW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:22:27 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48099 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbaIQVWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:22:25 -0400
Date: Wed, 17 Sep 2014 14:22:20 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH 2/2] dt-bindings: add devicetree bindings for st-pwm
 regulator
Message-ID: <20140917212220.GQ30918@lee--X1>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
 <1410959280-29662-3-git-send-email-zyw@rock-chips.com>
 <CAD=FV=WCQ4oU1O9JcZ9SuwWJ7g+GLsUiE=wmQQoWvL41o24eWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=WCQ4oU1O9JcZ9SuwWJ7g+GLsUiE=wmQQoWvL41o24eWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Doug Anderson wrote:
> On Wed, Sep 17, 2014 at 6:08 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> > Document the st-pwm regulator
> >
> > Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> >
> > ---
> >
> >  .../devicetree/bindings/regulator/st-pwm.txt       |   35 ++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/regulator/st-pwm.txt
> >
> > diff --git a/Documentation/devicetree/bindings/regulator/st-pwm.txt b/Documentation/devicetree/bindings/regulator/st-pwm.txt
> > new file mode 100644
> > index 0000000..38fec1d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/regulator/st-pwm.txt
> > @@ -0,0 +1,35 @@
> > +st pwm regulator bindings
> > +
> > +Required properties:
> > +  - compatible: "pwm-regulator"
> 
> This compatible string doesn't include "st,b2105-pwm-regulator".
> 
> Should be something like:
> 
>   - compatible: Should be "pwm-regulator" to get voltage table / regulator
>     period from the device tree.  Deprecated: if "st,b2105-pwm-regulator" then
>     voltage table and regulator will be handled by the driver.
> 
> Assuming that everyone is OK calling "st,b2105-pwm-regulator" the
> deprecated way of doing things.

It's okay not to deprecate "st,b2105-pwm-regulator" as there have
never been any users.  The only DTS file with a reference to it is in
my local repo.  Just rename it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

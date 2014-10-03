Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaJCNGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:06:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64021 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbaJCNGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:06:04 -0400
Date: Fri, 3 Oct 2014 14:05:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "atull@opensource.altera.com" <atull@opensource.altera.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v5 1/4] hwmon: ltc2978: device tree bindings documentation
Message-ID: <20141003130559.GJ26643@leverpostej>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
 <1412275071-6417-2-git-send-email-atull@opensource.altera.com>
 <20141003122736.GH26643@leverpostej>
 <542E9E9B.4090307@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542E9E9B.4090307@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 02:03:23PM +0100, Guenter Roeck wrote:
> On 10/03/2014 05:27 AM, Mark Rutland wrote:
> > On Thu, Oct 02, 2014 at 07:37:48PM +0100, atull@opensource.altera.com wrote:
> >> From: Alan Tull <atull@opensource.altera.com>
> >>
> >> Add device tree bindings documentation for ltc2978.
> >>
> >> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> >> ---
> >> v2: clean whitespace
> >> ---
> >>   .../devicetree/bindings/hwmon/ltc2978.txt          |   41 ++++++++++++++++++++
> >>   1 file changed, 41 insertions(+)
> >>   create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> >> new file mode 100644
> >> index 0000000..b2d9c4d
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> >> @@ -0,0 +1,41 @@
> >> +ltc2978
> >> +
> >> +Required properties:
> >> + - compatible: one of: ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676
> >
> > Could we please format this like:
> >
> > - compatible: should contain one of:
> >    * "ltc2974"
> >    * "ltc2977"
> >    * "ltc2978"
> >    * "ltc3880"
> >    * "ltc3883"
> >    * "ltm4676"
> >
> > Given the file name, are these all variants of ltc2978?
> >
> 
> All the chips supported by the ltc2978 driver. Some are variants
> of the ltc2978, some have different functionality.

Ok.

> 
> [ should those be "linear,ltc2974" and so on ? ]

Good point; yes they should. That will need a vendor-prefixes.txt
addition.

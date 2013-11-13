Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab3KMJmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:42:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58047 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758699Ab3KMJmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:42:38 -0500
Date: Wed, 13 Nov 2013 09:42:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv5 20/20] MAINTAINERS: add maintainer entry for thermal
 bindings
Message-ID: <20131113094232.GB21713@e106331-lin.cambridge.arm.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
 <1384285582-16933-21-git-send-email-eduardo.valentin@ti.com>
 <CAOesGMiCh-nGPqJQd4NPz9st7mBT0JkZ9nEK1gfyF2RmnrXZog@mail.gmail.com>
 <52828C31.2050604@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52828C31.2050604@ti.com>
Thread-Topic: [PATCHv5 20/20] MAINTAINERS: add maintainer entry for thermal
 bindings
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 12, 2013 at 08:14:41PM +0000, Eduardo Valentin wrote:
> On 12-11-2013 15:59, Olof Johansson wrote:
> > On Tue, Nov 12, 2013 at 11:46 AM, Eduardo Valentin
> > <eduardo.valentin@ti.com> wrote:
> >> After discussion and agreement of thermal device tree bindings,
> >> it is desirable to properly maintain thermal bindings for
> >> existing and upcoming devices.
> >>
> >> As original author of thermal device tree bindings, I am
> >> volunteering to maintain them.
> >>
> >> Cc: Rob Herring <rob.herring@calxeda.com>
> >> Cc: Pawel Moll <pawel.moll@arm.com>
> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> Cc: Stephen Warren <swarren@wwwdotorg.org>
> >> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> >> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> >> ---
> >>  MAINTAINERS | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 3438384..94bfc46 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -6178,6 +6178,7 @@ M:        Pawel Moll <pawel.moll@arm.com>
> >>  M:     Mark Rutland <mark.rutland@arm.com>
> >>  M:     Stephen Warren <swarren@wwwdotorg.org>
> >>  M:     Ian Campbell <ijc+devicetree@hellion.org.uk>
> >> +M:     Eduardo Valentin <eduardo.valentin@ti.com>
> >>  L:     devicetree@vger.kernel.org
> >>  S:     Maintained
> >>  F:     Documentation/devicetree/
> > 
> > The number of device-tree maintainers is getting to be somewhat silly.
> > You don't have to be a maintainer to be a reviewer, and the number is
> > getting large enough that it might get hard for one maintainer to know
> > what another is doing.
> > 
> > So, soft nack, but it's really up to the DT guys.
> 
> Hello Olof,
> 
> No issues on my side. As I stated in the patch description, I am
> volunteering. The motivation comes from the fact that it's been hard to
> get DT maintainers attention, so I am assuming they are not having
> enough bandwidth to pay attention to an extra class of bindings.
> 
> I agree with you, this is up to the DT folks.

When we discussed this in #devicetree, I was under the impression you
meant adding a line like:

F:      Documentation/devicetree/bindings/thermal/

To your MAINTAINERS entry, rather than adding yourself to the general
devicetree bindings MAINTAINERS entry. Sorry for the confusion regarding
this.

Given we have enough difficulty organising ourselves at present, I agree
with Olof that it doesn't make much sense to throw more people into the
general devicetree bindings maintainer pile.

However, we would certainly appreciate any review you'd be willing to
provide.

Thanks,
Mark.

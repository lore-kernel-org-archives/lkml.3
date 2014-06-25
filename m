Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbaFYKrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:47:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36225 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbaFYKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:47:38 -0400
Date: Wed, 25 Jun 2014 11:47:32 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Doug Anderson <dianders@chromium.org>,
        Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@linaro.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Documentation: devicetree: Fix tps65090 typos
Message-ID: <20140625104732.GE14495@leverpostej>
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>
 <1403486483-4063-4-git-send-email-afaerber@suse.de>
 <CAD=FV=UUGQ_ULm+juj0hMxCKhhcXTa2aJT50Y=WrePy9g8u-zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=UUGQ_ULm+juj0hMxCKhhcXTa2aJT50Y=WrePy9g8u-zA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:27:04PM +0100, Doug Anderson wrote:
> Andreas,
> 
> On Sun, Jun 22, 2014 at 6:21 PM, Andreas Färber <afaerber@suse.de> wrote:
> > It's vsys-l{1,2}-supply, not vsys_l{1,2}-supply.
> >
> > Signed-off-by: Andreas Färber <afaerber@suse.de>
> > ---
> >  Documentation/devicetree/bindings/regulator/tps65090.txt | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/regulator/tps65090.txt b/Documentation/devicetree/bindings/regulator/tps65090.txt
> > index 34098023..ca69f5e 100644
> > --- a/Documentation/devicetree/bindings/regulator/tps65090.txt
> > +++ b/Documentation/devicetree/bindings/regulator/tps65090.txt
> > @@ -45,8 +45,8 @@ Example:
> >                 infet5-supply = <&some_reg>;
> >                 infet6-supply = <&some_reg>;
> >                 infet7-supply = <&some_reg>;
> > -               vsys_l1-supply = <&some_reg>;
> > -               vsys_l2-supply = <&some_reg>;
> > +               vsys-l1-supply = <&some_reg>;
> > +               vsys-l2-supply = <&some_reg>;
> 
> Your change matches the code and all existing device trees in the
> Linux kernel.

Could this fact please be mentioned in the commit message?

Given that:

Acked-by: Mark Rutland <mark.rutland@arm.com>

> I also see plenty of other bindings with dashes, so this seems
> reasonable.

Dashes rather than underscores are preferred/correct for property names
and compatible strings. Given no-one can possibly be using the
bad/incorrect form with underscores, fixing the documentation to use
dashes makes sense.

Thanks,
Mark.

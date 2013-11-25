Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3KYQCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:02:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61467 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093Ab3KYQCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:02:01 -0500
Date: Mon, 25 Nov 2013 16:01:53 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Kumar Gala <galak@codeaurora.org>, devicetree <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH] dt-bindings: add ARMv8 PMU binding
Message-ID: <20131125160153.GI32081@e106331-lin.cambridge.arm.com>
References: <1385155032-9032-1-git-send-email-robherring2@gmail.com>
 <A8B9EAD7-0DBA-46D7-963F-30DEA0575EE2@codeaurora.org>
 <528FD003.8090607@gmail.com>
 <20131125091651.GA32081@e106331-lin.cambridge.arm.com>
 <CAL_JsqKArowT_DE8-vCJvmOSxjp+X9bngCXXsgjBK7G3wPZ7wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqKArowT_DE8-vCJvmOSxjp+X9bngCXXsgjBK7G3wPZ7wA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 03:24:46PM +0000, Rob Herring wrote:
> On Mon, Nov 25, 2013 at 3:16 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Fri, Nov 22, 2013 at 09:43:31PM +0000, Rob Herring wrote:
> >> On 11/22/2013 03:38 PM, Kumar Gala wrote:
> >> >
> >> > On Nov 22, 2013, at 3:17 PM, Rob Herring <robherring2@gmail.com> wrote:
> >> >
> >> >> From: Rob Herring <rob.herring@calxeda.com>
> >> >>
> >> >> Add missing "arm,armv8-pmuv3" compatible property for ARMv8 PMU.
> >> >>
> >> >> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> >> >> Cc: Will Deacon <will.deacon@arm.com>
> >> >> Cc: Pawel Moll <pawel.moll@arm.com>
> >> >> Cc: Mark Rutland <mark.rutland@arm.com>
> >> >> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> >> >> ---
> >> >> Documentation/devicetree/bindings/arm/pmu.txt | 1 +
> >> >> 1 file changed, 1 insertion(+)
> >> >>
> >> >> diff --git a/Documentation/devicetree/bindings/arm/pmu.txt b/Documentation/devicetree/bindings/arm/pmu.txt
> >> >> index 343781b..3e1e498 100644
> >> >> --- a/Documentation/devicetree/bindings/arm/pmu.txt
> >> >> +++ b/Documentation/devicetree/bindings/arm/pmu.txt
> >> >> @@ -7,6 +7,7 @@ representation in the device tree should be done as under:-
> >> >> Required properties:
> >> >>
> >> >> - compatible : should be one of
> >> >> +  "arm,armv8-pmuv3”
> >> >
> >> > what about arm,armv8-pmu-v3?
> >>
> >> I'm just documenting what is already being used:
> >>
> >> arch/arm64/boot/dts/foundation-v8.dts:          compatible =
> >> "arm,armv8-pmuv3";
> >> arch/arm64/boot/dts/rtsm_ve-aemv8a.dts:         compatible =
> >> "arm,armv8-pmuv3";
> >>
> >> Do we want to change those?
> >
> > It would probably have been nicer to have the '-' from the start, but
> > adding it now is only going to expand the set of compatible strings for
> > no appreciable benefit.
> >
> > I don't see any value in adding a new form of the string, and we can't
> > change the existing one as it's already in use.
> 
> Is that an ack then?
> 

Sure:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

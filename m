Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaLDKjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:39:25 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63382 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaLDKjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:39:22 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 1/3] devicetree: of: Add bindings for chosen
 =?iso-8859-1?Q?node=2C=0D?= stdout-path
To: frowand.list@gmail.com
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Ian Campbell <ijc@debian.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <547F97C5.7020202@gmail.com>
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
	<1417110967-16284-2-git-send-email-leif.lindholm@linaro.org>
	<547E7455.6090009@gmail.com>
	<CACxGe6vdbURE3=W3Uerwy90piGKhv7-m+-vpUhCiUTKB4AzTsw@mail.gmail.com>
	<547F6881.20400@gmail.com>
	<CACxGe6ugLyV50gKCe83wCL0=qy+oHeExf9murW+qFuoVQ_TzsA@mail.gmail.com>
	<547F97C5.7020202@gmail.com>
Date: Thu, 04 Dec 2014 10:39:14 +0000
Message-Id: <20141204103914.B2BACC40992@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2014 15:07:49 -0800
, Frank Rowand <frowand.list@gmail.com>
 wrote:
> On 12/3/2014 1:45 PM, Grant Likely wrote:
> > On Wed, Dec 3, 2014 at 7:46 PM, Frank Rowand <frowand.list@gmail.com> wrote:
> >> On 12/3/2014 7:12 AM, Grant Likely wrote:
> >>> On Wed, Dec 3, 2014 at 2:24 AM, Frank Rowand <frowand.list@gmail.com> wrote:
> >>>> On 11/27/2014 9:56 AM, Leif Lindholm wrote:
> >>>>> Add a global binding for the chosen node.
> >>>>> Include a description of the stdout-path, and an explicit statement on
> >>>>> its extra options in the context of a UART console.
> >>>>>
> >>>>> Opening description stolen from www.devicetree.org, and part of the
> >>>>> remaining text provided by Mark Rutland.
> >>>>>
> >>>>> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> >>>>> ---
> >>>>>  Documentation/devicetree/bindings/chosen.txt |   42 ++++++++++++++++++++++++++
> >>>>>  1 file changed, 42 insertions(+)
> >>>>>  create mode 100644 Documentation/devicetree/bindings/chosen.txt
> >>>>>
> >>>>> diff --git a/Documentation/devicetree/bindings/chosen.txt b/Documentation/devicetree/bindings/chosen.txt
> >>>>> new file mode 100644
> >>>>> index 0000000..9cd74e9
> >>>>> --- /dev/null
> >>>>> +++ b/Documentation/devicetree/bindings/chosen.txt
> >>>>> @@ -0,0 +1,42 @@
> >>>>> +The chosen node
> >>>>> +---------------
> >>>>> +
> >>>>> +The chosen node does not represent a real device, but serves as a place
> >>>>> +for passing data between firmware and the operating system, like boot
> >>>>> +arguments. Data in the chosen node does not represent the hardware.
> >>>>> +
> >>>>> +
> >>>>> +stdout-path property
> >>>>
> >>>> The code in patch 3/3 adds the extra options feature to the properties:
> >>>>
> >>>>   stdout-path
> >>>>   linux,stdout-path
> >>>>   stdout  [if (IS_ENABLED(CONFIG_PPC) ... ]
> >>>
> >>> I don't understand what you mean here. Are you suggesting a change to
> >>> this patch? Is there something deficient in it?
> >>
> >> Assuming that the code change in patch 3 is as desired, then the chosen.txt
> >> documentation applies to all three properties, not just stdout-path.  So
> >> yes, a change is suggested for the documentation.
> > 
> > how about if this is added:
> > 
> > Implementation note: Linux will look for the property "linux,stdout-path" or
> > on PowerPC "stdout" if "stdout-path" is not found.  However, the
> > "linux,stdout-path" and "stdout" properties are deprecated. New platforms
> > should only use the "stdout-path" property.
> > 
> > g.
> > 
> 
> Yep, perfect.

Great, thanks. Merged.

g.

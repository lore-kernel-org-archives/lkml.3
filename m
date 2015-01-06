Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbbAFN3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:29:31 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55857 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbbAFN33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:29:29 -0500
Date: Tue, 6 Jan 2015 13:29:21 +0000
From: Javi Merino <javi.merino@arm.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 9/9] of: thermal: Introduce sustainable power for
 a thermal zone
Message-ID: <20150106132921.GG2885@e104805>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-10-git-send-email-javi.merino@arm.com>
 <20150102155256.GD10683@developer>
 <20150106094215.GB2885@e104805>
 <20150106131301.GC4661@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150106131301.GC4661@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 01:13:03PM +0000, Eduardo Valentin wrote:
> On Tue, Jan 06, 2015 at 09:42:15AM +0000, Javi Merino wrote:
> > On Fri, Jan 02, 2015 at 03:53:00PM +0000, Eduardo Valentin wrote:
> > > On Fri, Dec 05, 2014 at 07:04:20PM +0000, Javi Merino wrote:
> > > > From: Punit Agrawal <punit.agrawal@arm.com>
> > > > 
> > > > Introduce an optional property called, sustainable-power, which
> > > > represents the power (in mW) which the thermal zone can safely
> > > > dissipate.
> > > > 
> > > > If provided the property is parsed and associated with the thermal
> > > > zone via the thermal zone parameters.
> > > > 
> > > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > > Cc: Eduardo Valentin <edubezval@gmail.com>
> > > > Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> > > > ---
> > > >  Documentation/devicetree/bindings/thermal/thermal.txt | 4 ++++
> > > >  drivers/thermal/of-thermal.c                          | 4 ++++
> > > >  2 files changed, 8 insertions(+)
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
> > > > index f5db6b72a36f..c6eb9a8d2aed 100644
> > > > --- a/Documentation/devicetree/bindings/thermal/thermal.txt
> > > > +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> > > > @@ -167,6 +167,10 @@ Optional property:
> > > >  			by means of sensor ID. Additional coefficients are
> > > >  			interpreted as constant offset.
> > > >  
> > > > +- sustainable-power:	An estimate of the sustainable power (in mW) that the
> > > > +  Type: unsigned	thermal zone can dissipate.
> > > > +  Size: one cell
> > > > +
> > > 
> > > Please, include examples of this property, as you mentioned in the
> > > governor documentation.
> > 
> > I'd rather put a pointer to the documentation instead of repeating the
> > same thing here.  What do you think?
> 
> The point is that device tree and Linux are supposed to be independent
> entities. I would prefer if you could extend the explanation of what is
> 'sustainable power' in the above entry. On top of that, pick one of the
> existing examples and extend it to include the 'sustainable-power' property,
> with a comment explaining it, for instance.

Ok, I'll do that.

Cheers,
Javi

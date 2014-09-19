Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbaISGRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 02:17:16 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38978 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaISGRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 02:17:14 -0400
Date: Fri, 19 Sep 2014 15:17:04 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@skyworksinc.com>
Subject: Re: [PATCH v2.2 2/2] dt-bindings: Adding compatible attribute for
 SKY81452 regulator
Message-ID: <20140919061704.GA3316@jack-ThinkPad-T520>
References: <20140813190423.GI17528@sirena.org.uk>
 <1409539218-5571-1-git-send-email-jack.yoo@skyworksinc.com>
 <1409539218-5571-3-git-send-email-jack.yoo@skyworksinc.com>
 <20140901103158.GO29327@sirena.org.uk>
 <20140905015507.GA2636@jack-ThinkPad-T520>
 <20140906143828.GJ2601@sirena.org.uk>
 <20140911052230.GA3764@jack-ThinkPad-T520>
 <20140915223554.GF7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140915223554.GF7960@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 03:35:54PM -0700, Mark Brown wrote:
> On Thu, Sep 11, 2014 at 02:22:30PM +0900, Gyungoh Yoo wrote:
> 
> > By the way,
> > I knew that compatible string is used for binding a driver.
> > http://devicetree.org/Device_Tree_Usage#Understanding_the_compatible_Property
> 
> > And, from kernel 3.6, MFD core has a mechanism for binding of_node
> > to the driver with of_compatible.
> 
> > Can I have a question about if it is possible to assign compatible string
> > for binding driver independently with reusability?
> 
> Look at a driver like the wm831x regulator drivers - they don't have
> device tree but they're reusing a driver for an IP with the base
> register for the IP being specified in the MFD.  If convering to DT it
> might be reasonable to specify this in device tree, though it's marginal
> since the part name in the core is also good enough.

Thank you for your comment.

I agree.
A child driver can look DT up and reference the base information
in MFD with or without compatible string.
My idea was about easy-binding of DT without referencing
parent node because the recent kernel support this infrastructure.
I will add more information in DT to reuse the driver for the IP,
and I will resubmit.

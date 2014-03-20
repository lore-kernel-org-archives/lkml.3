Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbaCTNTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:19:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52353 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756662AbaCTNTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:19:03 -0400
Date: Thu, 20 Mar 2014 13:19:00 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Simon Budig <simon.budig@kernelconcepts.de>
Cc: Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@karo-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Fugang Duan <B38611@freescale.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/5] Input: edt-ft5x06: Add DT support
Message-ID: <20140320131900.GC22115@e106331-lin.cambridge.arm.com>
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
 <1395234563-11034-3-git-send-email-LW@KARO-electronics.de>
 <20140320093719.GB14420@e106331-lin.cambridge.arm.com>
 <532ACE72.6030807@kernelconcepts.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <532ACE72.6030807@kernelconcepts.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 11:18:10AM +0000, Simon Budig wrote:
> On 20/03/14 10:37, Mark Rutland wrote:
> > On Wed, Mar 19, 2014 at 01:09:20PM +0000, Lothar Waßmann wrote:
> >> +FocalTech EDT-FT5x06 Polytouch driver
> >> +=====================================
> >> +
> >> +Required properties:
> >> + - compatible:  "edt,edt-ft5x06"
> > 
> > Is the 'x' part of a particular product name, or is this a class of
> > devices?
> 
> The driver is intended for the EDT "polytouch" family touches, which are
> based on a focaltec controller. The current line of touches uses e.g.
> the ft5306 as well as the ft5406 focaltec controller.

Ok. The name of the driver and the strings used in DT bindings don't
have to be the same. The bindings strings should describe the hardware
as accurately as possible.

> 
> > It's preferable to have a specific string which another similar variants
> > can claim compatibility with (while also additionally having a more
> > specific string), as this makes it possible to handle variants more
> > specially in future, target workarounds, etc.
> 
> I chose the driver name since I wanted to differentiate from other EDT
> touches, which used a different controller. With hindsight it was
> unfortunately confusing, since I get quite some request from people, who
> also have a device based on the focaltec controllers, but with a very
> different firmware (and communication protocol). They got tricked into
> thinking that this driver would be suitable...
> 
> If I were to chose the name again I'd probably pick "edt-polytouch" or
> something like this. But I doubt that it is useful to change the name now.

I'm not arguing to rename the driver. All I want are the compatible
strings to be as specific as possible.

Cheers,
Mark.

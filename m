Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaJJNS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:18:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52150 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbaJJNSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:18:25 -0400
Date: Fri, 10 Oct 2014 14:17:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Mark Brown <broonie@kernel.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/5] regulator: of: Add regulator-initial-mode parse
 support
Message-ID: <20141010131759.GB6004@leverpostej>
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk>
 <1412775847-15213-2-git-send-email-javier.martinez@collabora.co.uk>
 <20141008142511.GA4609@sirena.org.uk>
 <54354C7D.7090104@collabora.co.uk>
 <20141008151220.GE4609@sirena.org.uk>
 <54356666.4090003@collabora.co.uk>
 <20141009102717.GG3869@leverpostej>
 <5436A793.6090204@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5436A793.6090204@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 04:19:47PM +0100, Javier Martinez Canillas wrote:
> Hello Mark,
> 
> On 10/09/2014 12:27 PM, Mark Rutland wrote:
> >> 
> >> Well, is not fairly obvious to me. One can also say the opposite, why the
> >> kernel is documenting a DT binding that is not (currently) implemented?
> > 
> > Checkpatch will complain regarding undocumented bindings, so from a
> > pragmatic point of view the binding must come first.
> >
> > Personally, when I read a patch series I do an initial pass in-order,
> > and having the binding first makes things clearer. I might have some
> > questions regarding the binding that the driver answers later, and it makes it
> > easier to spot undocumented properties or conventions used by the
> > driver. Doing so the other way around usually leaves me with more
> > questions at the end.
> >
> 
> Thanks a lot for the explanation, it certainly makes sense then to have
> the DT binding before. I'll propose a patch to add that information to
> Documentation/devicetree/bindings/submitting-patches.txt so people
> (like me) who didn't find it obvious can know what the convention is.

That sounds like a good idea; yes please.

Thanks,
Mark.

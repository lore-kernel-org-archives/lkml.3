Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3D2OMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:12:53 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:51434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab3D2OMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:12:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] media: i2c: mt9p031: add OF support
Date: Mon, 29 Apr 2013 16:12:57 +0200
Message-ID: <1699729.OjpLK67acQ@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CA+V-a8ubM9NXA4XNACjXiO1RKRzVmaXOdoM4EyPx96m7S=ffVw@mail.gmail.com>
References: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com> <3228007.esFOONCu9m@avalon> <CA+V-a8ubM9NXA4XNACjXiO1RKRzVmaXOdoM4EyPx96m7S=ffVw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 April 2013 17:18:02 Prabhakar Lad wrote:
> On Mon, Apr 29, 2013 at 5:05 PM, Laurent Pinchart wrote:
> > Hi Prabhakar,
> > 
> > Thank you for the patch. Please see below for a couple of comments in
> > addition to the ones I've just sent (in reply to Sascha's e-mail).
> 
> Yep fixed them all.
> 
>  [snip]
> 
> >> ---
> >> 
> >>  .../devicetree/bindings/media/i2c/mt9p031.txt      |   43 ++++++++++++++
> >>  drivers/media/i2c/mt9p031.c                        |   61 +++++++++++++-
> >>  2 files changed, 103 insertions(+), 1 deletions(-)
> >>  create mode 100644
> >>  Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> >> 
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> >> b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt new file mode
> >> 100644
> >> index 0000000..b985e63
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> >> @@ -0,0 +1,43 @@
> >> +* Aptina 1/2.5-Inch 5Mp CMOS Digital Image Sensor
> >> +
> >> +The Aptina MT9P031 is a 1/2.5-inch CMOS active pixel digital image
> >> +sensor with an active imaging pixel array of 2592H x 1944V. It
> >> +incorporates sophisticated camera functions on-chip such as windowing,
> >> +column and row skip mode, and snapshot mode. It is programmable through
> >> +a simple two-wire serial interface.
> >> +The MT9P031 is a progressive-scan sensor that generates a stream of
> >> +pixel data at a constant frame rate. It uses an on-chip, phase-locked
> >> +loop (PLL) to generate all internal clocks from a single master input
> >> +clock running between 6 and 27 MHz. The maximum pixel rate is 96 Mp/s,
> >> +corresponding to a clock rate of 96 MHz.
> > 
> > Isn't this text (directly copied from the datasheet) under Aptina's
> > copyright ?
> 
> hmm :) do you want me change it ?

>From a personal point of view I don't care much, and I don't think Aptina 
would either, but I'd rather be safe than sorry on such matters, so it would 
probably be a good idea to change the text. One or two sentences should be 
enough.

-- 
Regards,

Laurent Pinchart


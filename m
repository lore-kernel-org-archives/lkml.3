Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3BCNOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:14:00 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:55701 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab3BCNN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:13:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] media: tvp514x: add OF support
Date: Sun, 03 Feb 2013 14:14 +0100
Message-ID: <1832736.hCOhBbmy4r@avalon>
User-Agent: KMail/4.9.5 (Linux/3.6.11-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+V-a8u6VADw_HfbBN4ESGUXTSMKfVyKZaEf1bhVGACof6qZ8A@mail.gmail.com>
References: <1359464832-8875-1-git-send-email-prabhakar.lad@ti.com> <510C43A0.7090906@gmail.com> <CA+V-a8u6VADw_HfbBN4ESGUXTSMKfVyKZaEf1bhVGACof6qZ8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Sunday 03 February 2013 15:43:49 Prabhakar Lad wrote:
> On Sat, Feb 2, 2013 at 4:07 AM, Sylwester Nawrocki wrote:
> > On 01/29/2013 02:07 PM, Prabhakar Lad wrote:
> > [...]
> > 
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> >> b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> >> new file mode 100644
> >> index 0000000..55d3ffd
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> >> @@ -0,0 +1,38 @@
> >> +* Texas Instruments TVP514x video decoder
> >> +
> >> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality,
> >> +single-chip digital video decoder that digitizes and decodes all popular
> >> +baseband analog video formats into digital video component. The tvp514x
> >> +decoder supports analog-to-digital (A/D) conversion of component RGB and
> >> +YPbPr signals as well as A/D conversion and decoding of NTSC, PAL and
> >> +SECAM composite and S-video into component YCbCr.
> >> +
> >> +Required Properties :
> >> +- compatible: Must be "ti,tvp514x-decoder"
> > 
> > There are no significant differences among TVP514* devices as listed
> > above, you would like to handle above ?
> > 
> > I'm just wondering if you don't need, for instance, two separate
> > compatible properties, e.g. "ti,tvp5146-decoder" and "ti,tvp5147-decoder"
> > ?
> 
> There are few differences in init/power sequence tough, I would still
> like to have single compatible property "ti,tvp514x-decoder", If you feel we
> need separate property I will change it please let me know on this.

If there's any difference between the chips that need to be handled in the 
driver, using two compatible properties is a good practice. Your driver will 
then be able to easily differentiate between the two chips, and there's no 
real drawback in doing so.

-- 
Regards,

Laurent Pinchart


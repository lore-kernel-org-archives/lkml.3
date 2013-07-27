Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab3G0LgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 07:36:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50601 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3G0LgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 07:36:15 -0400
Date: Sat, 27 Jul 2013 12:36:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Message-ID: <20130727113602.GD9858@sirena.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
 <20130726171524.GB28895@obsidianresearch.com>
 <20130727085259.GA6207@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wqjXpb7PT9zw0UX/"
Content-Disposition: inline
In-Reply-To: <20130727085259.GA6207@netboy>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wqjXpb7PT9zw0UX/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 27, 2013 at 10:53:01AM +0200, Richard Cochran wrote:
> On Fri, Jul 26, 2013 at 11:15:24AM -0600, Jason Gunthorpe wrote:

> > Why do you think our experiences are so different?

> Here are a few recent examples:

OK, let's go through these...

> * What happens when one wants to boot vanilla kernel on the beaglebone?

>   http://www.spinics.net/lists/arm-kernel/msg198431.html

This actually sounds pretty good - glancing over the thread it seems you
were trying to boot a shiny new board that people were in the process of
trying to upstream support for and were just a bit too early.  Device
tree doesn't seem to have made a difference either way here.

> * Wanting already merged code to work is too much to ask.

>   http://www.spinics.net/lists/linux-omap/msg79731.html

Paul's reply here seems fairly clear - someone had merged a driver which
had been developed in an out of tree or pre-DT environment without DT
support so they just hadn't added DT support.  Sadly doing that is new
feature development and so not appropriate for the stabalisation phase
of development.

> * When people try in good faith to conduct methodical boot tests,
>   DT is working against them.

>   http://www.spinics.net/lists/linux-omap/msg79960.html

Again I don't see anything particularly related to DT here but instead
do with using a SoC and board that are in the early phases of mainline
integration.

I think what you're seeing here is not to do with DT but rather with the
way most SoC vendors engage with mainline - typically they do their SoC
bringup out of tree and then if things do get submitted to mainline that
happens after the SoC is released.  In this respect things seem to have
been going relatively well here, there were clearly active efforts to
get things integrated and facilitate mainline use.

It'd be much better if SoC vendors were to change the way they engage
with the kernel so that support was already in mainline at about the
time the SoC was released but that's a bigger commercial discussion
which isn't really relevant to this one.

--wqjXpb7PT9zw0UX/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR87CfAAoJELSic+t+oim9cpIP/2WXy0UmOxOqh/xhVTEVnBJW
CjJvQz40aPiR2Pc6EU3YswYnsaDnLgdKmJoVqHPudnFsdYo4EkgxKhQsHvB5oe9F
hBbCMhRWzboW9lNS1o9VjOTA5AVCFAqLUvkekUMdwVv4LeIT1un7LsCWH2iTJUVA
J0pkd/fiKT89Kn3PRhb0+1JxEcu81k/5/i/W13M5cC/B048A5iRoI/61B6GD5VVO
DorWFiXsVXWwdIWigHJA1vvKQ5GLcRLERWbq2y3AaME4OLgfHcRAks+/2wlDtFzh
ZS5aS2K+rfgFXxgVYOMHVajqio+S5EdmFccuOVgTfkQQutKq0azlsWJzDVoDZdoh
F4ukB3BW8d5NvQAYq5oMI7jkCGUmmXWGs8DZ9xdMPOviC/FJrvunsu5YQx2wJ5BF
Jhr+ILJyFfmR7FXkzRMvRCIS4uqvdpVxk/xYGzoCIFKufMr0UAObY0OUwdamnU16
CwctNe/Zvk+ojXAqpdwdcvygtWOrfIXA9Zcs1XZxKPhgwNq4iqFUoDxPxMInDMto
yO3ievwt9Ktalp2npdhR8UOKAYhiJi0dMgSZLiM4sGUZyN8AlBopekDJcty1ryMt
gneo7u/ueVHcaIMwk2ioQfU35kBasM0EdI7WHDU1BQnGMocNYFh6BsxdFcAjF4N3
IM8DOIRAp+0gpU2Y0Vup
=iWWJ
-----END PGP SIGNATURE-----

--wqjXpb7PT9zw0UX/--

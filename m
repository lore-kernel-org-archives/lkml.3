Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030892Ab3HITom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:44:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34375 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030814Ab3HITol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:44:41 -0400
Date: Fri, 9 Aug 2013 20:44:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130809194434.GP6427@sirena.org.uk>
References: <20130808132201.2610aef3@armhf>
 <5204A716.6070507@gmail.com>
 <20130809091953.GO6427@sirena.org.uk>
 <5204B7A6.9050907@gmail.com>
 <20130809094340.GO23006@n2100.arm.linux.org.uk>
 <5204CC04.4000401@gmail.com>
 <20130809113940.GY6427@sirena.org.uk>
 <20130809130932.GS23006@n2100.arm.linux.org.uk>
 <20130809180058.GM6427@sirena.org.uk>
 <20130809182516.GT23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+PRXPAOP3MYWro6n"
Content-Disposition: inline
In-Reply-To: <20130809182516.GT23006@n2100.arm.linux.org.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu audio
 subsystem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+PRXPAOP3MYWro6n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2013 at 07:25:16PM +0100, Russell King - ARM Linux wrote:

> Sigh, you completely miss the point.

> What all three of us are ultimately after is a DT description for the
> kirkwood stuff which covers all its use cases.  The use case which all
> three of us have in common is the Cubox, which is the one which needs
> the spdif stuff to work.

I think I get what needs to be done well enough, I'm not sure that
matches up with what people are wanting the results to look like but
that's another story.

> Now, what you've said to date is:

> 1. you want kirkwood to use DPCM.

Yes.

> 2. you want kirkwood using people to use the simple card stuff with the
>    kirkwood driver you want to use DPCM.

No.  What I'm saying is that if your end goal is a binding for cards
that works for absolutely anything then it should be handled by the
simple card driver since that's what it's there for.   There's no
requirement to do things that way though, certainly not in a first pass.

> To make it work with DPCM, we first need to know what DPCM requires,
> which means we either have to have the knowledge of DPCM and/or have a
> working implementation.  We don't have either of those yet.

> So, I again state plainly that what you're asking is for people to come
> up with a DT description for a DPCM implementation when we haven't yet
> got a working DPCM implementation, even without DT.

> It is this which I assert is a completely rediculous request at this
> moment in time for the reasons stated in my previous email and repeated
> in this email.

I'm not sure I said that anyone need do anything right this very minute? =
=20

In any case since the binding that pulls everything together into the
audio subsystem is supposed to be separate to the bindings for the
bindings for individual components it should be possible to proceed with
those if someone wants to do that (as in the patch under discussion) and
add the bits to tie things together later.

If someone wants to it should also be possible to convert the existing
platforms without S/PDIF support over to DT, providing you don't mind
changing the code once the DPCM and S/PDIF support is added and a bit of
thought is put into where the S/PDIF output will fit into the bindings.
Since DPCM is a Linux internal thing it shouldn't have any impact on the
bindings.

But like I say there's no need to do anything in particular immediately.
The patch under discussion seems basically fine for what it covers,
modulo the fairly minor things Sebastian identified, and can be built on
later.

--+PRXPAOP3MYWro6n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBUafAAoJELSic+t+oim91DsP/3koMr70cjpnMXMU8eO1U2Mh
3DovvF9PkYKt1CPB9nNwubE833ezqr+yGbRvHtIal/A5GaoL1ySwPkY0yP9H8Er2
JV8OPkBErhV9v7PeV9NfUh5/Z8Bi/AXNLebnDJoC/1wLoEP4Zrr5PJ1KYOREjxXo
eOH937uevv/sgxCyDVniL1T2wkr5iLUMu0CqOEPGfoPpnbB7KqRzXRSE9t1Q/0Ua
GusV7MrghYROL0COZ1L1QnfAjD5+IkSCY/jgwpuMnYZWIkCAAtpOOYxvz3pU/aLM
hXWeXLQ94Ydn21H5nx0YrTb1H4xBDOfu4gsVowx3XpS/7xwIXy8+rgqV59szNhYg
D6vgUgAW6VR0aFrqDmQWV8mKDs0wNWRrcq/grJi7wVnMCwKllu41aDQCYTIEvkPy
GXKgRy64qozchzwcRLAgyoJmq1abF8KyL/fBH2VzLqkWmSYws+do1RCKri0NBxFH
A5Fap2DGI6LCOhAKAvuw+YYQrRmO+8svApD40FdbRaBdzqfzJzh7joi3WBp/OiRL
l7R0d9BH6qEUuha2EKvoZ+qXKmfNQzGt/hADpBT1LPdOfmA3WyZgT4KZ1OWc9w3f
fc2u2TDze6JwDWH59nPtd54h8gf1imGSCIj/4REekdt1QKxgWqcOWlAfhM/uUDK0
cY+ExFLMWQzqBA/Dj5AM
=MPuB
-----END PGP SIGNATURE-----

--+PRXPAOP3MYWro6n--

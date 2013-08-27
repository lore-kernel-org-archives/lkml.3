Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3H0T6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:58:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35027 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3H0T6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:58:02 -0400
Date: Tue, 27 Aug 2013 14:56:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
CC: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Benoit Cousson <bcousson@baylibre.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
Message-ID: <20130827195652.GE3005@radagast>
Reply-To: <balbi@ti.com>
References: <CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com>
 <521CA888.1080909@baylibre.com>
 <521CAF59.1090203@linutronix.de>
 <521CB046.9070408@baylibre.com>
 <521CB18B.4080000@linutronix.de>
 <521CB239.6050409@baylibre.com>
 <521CB403.8010307@linutronix.de>
 <20130827173732.GC21564@kroah.com>
 <20130827183732.GP3005@radagast>
 <20130827193021.GA30113@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fLJtL2Vwvoz5kz8d"
Content-Disposition: inline
In-Reply-To: <20130827193021.GA30113@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fLJtL2Vwvoz5kz8d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 27, 2013 at 12:30:21PM -0700, Greg KH wrote:
> On Tue, Aug 27, 2013 at 01:37:32PM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Aug 27, 2013 at 10:37:32AM -0700, Greg KH wrote:
> > > On Tue, Aug 27, 2013 at 04:13:23PM +0200, Sebastian Andrzej Siewior w=
rote:
> > > > On 08/27/2013 04:05 PM, Benoit Cousson wrote:
> > > > > On 27/08/2013 16:02, Sebastian Andrzej Siewior wrote:
> > > > >> On 08/27/2013 03:57 PM, Benoit Cousson wrote:
> > > > >>> + Kevin,
> > > > >>>
> > > > >>> On 27/08/2013 15:53, Sebastian Andrzej Siewior wrote:
> > > > >>>> What do we do now?
> > > > >>>
> > > > >>> Cannot you just merge the stable arm-soc/dt branch into your br=
anch
> > > > >>> before applying your patches?
> > > > >>
> > > > >> That is up to Greg. This changes sat in his usb-next tree for a =
while
> > > > >> now. And before they hit Greg they were in Felipe's tree for a w=
hile.
> > > > >>
> > > > >> To be exact, last .dts change via USB was:
> > > > >>
> > > > >> Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > > >> AuthorDate: Thu Jun 20 12:13:04 2013 +0200
> > > > >> Commit:     Felipe Balbi <balbi@ti.com>
> > > > >> CommitDate: Fri Aug 9 17:40:16 2013 +0300
> > > > >>
> > > > >>     usb: musb dma: add cppi41 dma driver
> > > > >=20
> > > > > Mmm, if that branch is supposed to be stable, I'm not sure it wil=
l be
> > > > > doable...
> > > > >=20
> > > > > Maybe we should do the other way around? And merge usb-next into
> > > > > arm-soc/dt.
> > > > >=20
> > > > > Kevin, Olof?
> > > >=20
> > > > Please be aware that I have no response so far regarding [0] from G=
reg.
> > > >=20
> > > > [0] http://www.spinics.net/lists/linux-usb/msg92595.html
> > >=20
> > > Nor will you, given that I am not the one to take these patches, Feli=
pe
> > > is.  I noticed now that you said "please route around Felipe", but
> > > sorry, no, I'm not going to do that unless there's a really good reas=
on.
> > > Felipe seems to be around at the moment, please work with him on this.
> >=20
> > If you will still take a 'part2' pull request from me, I can send you
> > urgent bugfixes by friday. If I have some time left, I can even try to
> > get that sorted out by tomorrow.
>=20
> For 3.12 stuff, like "fixes", sure, I can take them this week, that
> should give us a week or so for linux-next testing, right?

that's correct. I have most of them already queued up, let me just go
over my linux-usb maildir again and make sure I got all the important
stuff in.

cheers, thanks for opening this 'window'.

--=20
balbi

--fLJtL2Vwvoz5kz8d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHQSEAAoJEIaOsuA1yqRE/v8P/09fTxEq3rzBWWKN5gJapG7O
eG0xpfEVvQFUWbet7DWRQjehRc8bVVemPsH295hv2yV1yUGoJIps5RQnv6vbj2Ka
fMTs0G7YDoHDDkg2SgxqeTRxGoLgnuE4QXqzgRZhsyGSjTfBYhUDjfQyGVGGgy2a
+Nmri9qm6JcTfCpwxeSQsSZnT1XYda7p2WCmLcJ21fJymmOaanNoQG9wh15U2qFJ
z33YOaZwOFLfrYNkyWaXo4lbNNXb0c43GlnF3fbKnoAhWiL1LJj/FOTW6sN7yd1d
ZzhZzKdhVGSekH/RK8ehitVBHlRgZMNpQ2MdhUsFLnp2NdcGb6l2jwCf1GgXwBiy
qniR0kqaTSB6fHtRQYq0EutLdsa4xGEPn5M106D9MLiYxWolUhqyLRmu64FGIb7D
JwIO3SWhecaf2xQWtkOBn8k5o06kzwNsEh8qFs2uk6YXlBDQcVaBoXXuUvkP5Xpx
g2yETkFoTB5WIHOC7IUnpTIxAe/msi3P9XFs0G2TAJePxYWGvilKSaQvWtS5f/LG
Ta5AcrtDQHHF46qzU68iIlxVRuMohdfywYme1qcp/sdkVpFbvotxmwKDKOUIirVr
ARAlH7gdH8vy8SKP2qHsImKU+rkgicM1azRBAiD5L6TFuHR+20euSTR9/I9CM71+
kSjYqYdRlgVn6Yqwieqg
=0im4
-----END PGP SIGNATURE-----

--fLJtL2Vwvoz5kz8d--

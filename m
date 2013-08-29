Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3H2OYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:24:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59592 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3H2OYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:24:17 -0400
Date: Thu, 29 Aug 2013 09:23:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: <balbi@ti.com>, Greg KH <greg@kroah.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
Message-ID: <20130829142302.GJ9325@radagast>
Reply-To: <balbi@ti.com>
References: <521CAF59.1090203@linutronix.de>
 <521CB046.9070408@baylibre.com>
 <521CB18B.4080000@linutronix.de>
 <521CB239.6050409@baylibre.com>
 <521CB403.8010307@linutronix.de>
 <20130827173732.GC21564@kroah.com>
 <20130827183732.GP3005@radagast>
 <20130827193021.GA30113@kroah.com>
 <20130827195652.GE3005@radagast>
 <521F1D28.7070003@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1BdFSKqAqVdu8k/"
Content-Disposition: inline
In-Reply-To: <521F1D28.7070003@baylibre.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--k1BdFSKqAqVdu8k/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2013 at 12:06:32PM +0200, Benoit Cousson wrote:
> Hi Felipe
>=20
> On 27/08/2013 21:56, Felipe Balbi wrote:
> >Hi,
> >
> >On Tue, Aug 27, 2013 at 12:30:21PM -0700, Greg KH wrote:
> >>On Tue, Aug 27, 2013 at 01:37:32PM -0500, Felipe Balbi wrote:
> >>>Hi,
> >>>
> >>>On Tue, Aug 27, 2013 at 10:37:32AM -0700, Greg KH wrote:
> >>>>On Tue, Aug 27, 2013 at 04:13:23PM +0200, Sebastian Andrzej Siewior w=
rote:
> >>>>>On 08/27/2013 04:05 PM, Benoit Cousson wrote:
> >>>>>>On 27/08/2013 16:02, Sebastian Andrzej Siewior wrote:
> >>>>>>>On 08/27/2013 03:57 PM, Benoit Cousson wrote:
> >>>>>>>>+ Kevin,
> >>>>>>>>
> >>>>>>>>On 27/08/2013 15:53, Sebastian Andrzej Siewior wrote:
> >>>>>>>>>What do we do now?
> >>>>>>>>
> >>>>>>>>Cannot you just merge the stable arm-soc/dt branch into your bran=
ch
> >>>>>>>>before applying your patches?
> >>>>>>>
> >>>>>>>That is up to Greg. This changes sat in his usb-next tree for a wh=
ile
> >>>>>>>now. And before they hit Greg they were in Felipe's tree for a whi=
le.
> >>>>>>>
> >>>>>>>To be exact, last .dts change via USB was:
> >>>>>>>
> >>>>>>>Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >>>>>>>AuthorDate: Thu Jun 20 12:13:04 2013 +0200
> >>>>>>>Commit:     Felipe Balbi <balbi@ti.com>
> >>>>>>>CommitDate: Fri Aug 9 17:40:16 2013 +0300
> >>>>>>>
> >>>>>>>     usb: musb dma: add cppi41 dma driver
> >>>>>>
> >>>>>>Mmm, if that branch is supposed to be stable, I'm not sure it will =
be
> >>>>>>doable...
> >>>>>>
> >>>>>>Maybe we should do the other way around? And merge usb-next into
> >>>>>>arm-soc/dt.
> >>>>>>
> >>>>>>Kevin, Olof?
> >>>>>
> >>>>>Please be aware that I have no response so far regarding [0] from Gr=
eg.
> >>>>>
> >>>>>[0] http://www.spinics.net/lists/linux-usb/msg92595.html
> >>>>
> >>>>Nor will you, given that I am not the one to take these patches, Feli=
pe
> >>>>is.  I noticed now that you said "please route around Felipe", but
> >>>>sorry, no, I'm not going to do that unless there's a really good reas=
on.
> >>>>Felipe seems to be around at the moment, please work with him on this.
> >>>
> >>>If you will still take a 'part2' pull request from me, I can send you
> >>>urgent bugfixes by friday. If I have some time left, I can even try to
> >>>get that sorted out by tomorrow.
> >>
> >>For 3.12 stuff, like "fixes", sure, I can take them this week, that
> >>should give us a week or so for linux-next testing, right?
> >
> >that's correct. I have most of them already queued up, let me just go
> >over my linux-usb maildir again and make sure I got all the important
> >stuff in.
> >
> >cheers, thanks for opening this 'window'.
>=20
> There are two patches in my DTS tree that conflict with the usb-next.
>=20
> I will remove that one (ARM: dts: AM33XX: don't redefine OCP bus and
> device nodes) , as suggested by Olof, since it is the biggest source
> of conflict from my tree.
>=20
> The second one is easily fixable, and Stephen already did it, but it
> will be even better it you could take it in your tree.
> This is the patch you did that I just slightly renamed (ARM: OMAP5:
> dts: fix reg property size).

I'm done with Pull requests for Greg. If the conflict is easy to solve,
what's the problem in having the conflict to start with ?

--=20
balbi

--k1BdFSKqAqVdu8k/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSH1lGAAoJEIaOsuA1yqRE4FIP/RwAntjf7UJ/LIno/lYM8+hJ
7jepbhZZD9Dd7yK3y/UCaaiUUjqBBeSYuUJ3UaOUFslCEQcd7C7eEBvbA/ntnpBe
jyKx1J6Yo0ky29GQw4dbjETIIt7xI2jYZKyXw9dSlzgLhZUvuUvhP8LNgAdJb2uX
Pab74Let8XJRan/OisYp1V24/AHndfHm8sk48jdONwC/uT3rwzjqlJKL+geLAnhc
AG8VoWrethLkmMvM96z97RfJR6zwgESq0Oo2hlQBC06hxexWYSdaXM1+sjiVXTQ8
l5kCEj0At07mNw9NfcPmBl9+65fQNrjzcw1XxyWjbao+Aatc4oVJYxOYbhbTX2Ie
SyNbsf4wYIiSgr7qbDlp6rdpc8esXtWilSCLNIwZUP7BTu8eeVyog/fOfVLlHMAb
DF2duSE0mbllx1oivdg+P8q/EAJgZYLq969HznwR/CPdiFkmXwku2m4aoVARF2Es
YKOvzXSp50HySYx7gVZcd2BU9RAz9mEmDEc3yqQRy/kFomfl16ZSHyhmQTGEuPDf
6nfpJlcfomXcQsgHFoFuwAluZgd3QgZOl5gXA5b5OQfF0nWZZTZiVoBBZne2PJzS
AzF22hYyujj7SJqQXT5iDv35abfPQlA2qhCaCwWiRptP/YQGd54tm1J9NXuMlTbu
+4ACjjhy/KhFDMgyYXSd
=JzaK
-----END PGP SIGNATURE-----

--k1BdFSKqAqVdu8k/--

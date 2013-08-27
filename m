Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3H0Sip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:38:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36745 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab3H0Sin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:38:43 -0400
Date: Tue, 27 Aug 2013 13:37:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Benoit Cousson <bcousson@baylibre.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        <linux-next@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
Message-ID: <20130827183732.GP3005@radagast>
Reply-To: <balbi@ti.com>
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au>
 <521C6961.9020103@linutronix.de>
 <CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com>
 <521CA888.1080909@baylibre.com>
 <521CAF59.1090203@linutronix.de>
 <521CB046.9070408@baylibre.com>
 <521CB18B.4080000@linutronix.de>
 <521CB239.6050409@baylibre.com>
 <521CB403.8010307@linutronix.de>
 <20130827173732.GC21564@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zyDKzlOwWcg4zI1m"
Content-Disposition: inline
In-Reply-To: <20130827173732.GC21564@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zyDKzlOwWcg4zI1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 27, 2013 at 10:37:32AM -0700, Greg KH wrote:
> On Tue, Aug 27, 2013 at 04:13:23PM +0200, Sebastian Andrzej Siewior wrote:
> > On 08/27/2013 04:05 PM, Benoit Cousson wrote:
> > > On 27/08/2013 16:02, Sebastian Andrzej Siewior wrote:
> > >> On 08/27/2013 03:57 PM, Benoit Cousson wrote:
> > >>> + Kevin,
> > >>>
> > >>> On 27/08/2013 15:53, Sebastian Andrzej Siewior wrote:
> > >>>> What do we do now?
> > >>>
> > >>> Cannot you just merge the stable arm-soc/dt branch into your branch
> > >>> before applying your patches?
> > >>
> > >> That is up to Greg. This changes sat in his usb-next tree for a while
> > >> now. And before they hit Greg they were in Felipe's tree for a while.
> > >>
> > >> To be exact, last .dts change via USB was:
> > >>
> > >> Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > >> AuthorDate: Thu Jun 20 12:13:04 2013 +0200
> > >> Commit:     Felipe Balbi <balbi@ti.com>
> > >> CommitDate: Fri Aug 9 17:40:16 2013 +0300
> > >>
> > >>     usb: musb dma: add cppi41 dma driver
> > >=20
> > > Mmm, if that branch is supposed to be stable, I'm not sure it will be
> > > doable...
> > >=20
> > > Maybe we should do the other way around? And merge usb-next into
> > > arm-soc/dt.
> > >=20
> > > Kevin, Olof?
> >=20
> > Please be aware that I have no response so far regarding [0] from Greg.
> >=20
> > [0] http://www.spinics.net/lists/linux-usb/msg92595.html
>=20
> Nor will you, given that I am not the one to take these patches, Felipe
> is.  I noticed now that you said "please route around Felipe", but
> sorry, no, I'm not going to do that unless there's a really good reason.
> Felipe seems to be around at the moment, please work with him on this.

If you will still take a 'part2' pull request from me, I can send you
urgent bugfixes by friday. If I have some time left, I can even try to
get that sorted out by tomorrow.

cheers

--=20
balbi

--zyDKzlOwWcg4zI1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHPHsAAoJEIaOsuA1yqREvbkP+QHprTQtdnFUmvyRKAxyODl4
lnoANWRL4+/uVt1RaRBuYjji6FgwwmZRAoReKcwysCpdLONwfeav00jfLBBZfnrE
AFKZczbBneubE0iHlkthg9YX9XHouJzz3isbrJtogGmYpbL40sENz+rYoBlhd7tc
T84kpZ0QL91Z3vIRnziBu3LM2THIUhUe/H64oDoPF8e2KPBT9eiWx1tTje+EaWqg
6EHMKQEkILptQ5CI7/qRy38Cz3CXhtTdpcjPzO242MBUUM8wl9ULHDknBCxzGOui
C03d8JbE/tXTp7NM8PICGK5dlIupxByFnCE9apDaTQSYd6K4+u2WbaRL2nRwOxDR
pJ9B/TArQhwnIbXwgT3pKTF5EIR6jE//bougbnrFSh19zM71nm5SnOGwLIJ6qMNn
SQKOWPgQ72yKbKbnCYhbxQbbi1yC7NVMLgDFCCVIfTUGFa3X0z2CFrc4oHFU9ivU
JKVe/pCb+QkBqXlJPjRBjK4Cw3yZxytQuZhA4GXTYYw2g9BTEjwfEdFbBGz/Dcxq
EDzuuxCWjslS3RWN70bxhHlxDVc2R76AYIcoktPR34LJhLcsolnJa2qEXIfbTyJ+
9eygUTTCCkfd9+7G3guGQ+6jRA0Qqu1ZBR6EDdWUoLY0Qq/WkSv2CpZlykKEIQq7
LknpQ4ZKN242WHipb4Qi
=kGKt
-----END PGP SIGNATURE-----

--zyDKzlOwWcg4zI1m--

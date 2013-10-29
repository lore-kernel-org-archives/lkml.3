Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3J2HEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:04:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55910 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3J2HEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:04:20 -0400
Date: Tue, 29 Oct 2013 18:04:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: =?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Suneel Garapati <suneelg@xilinx.com>,
        Vlad Lungu <vlad.lungu@windriver.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-Id: <20131029180402.5b62321cff41e1352a7ba3f7@canb.auug.org.au>
In-Reply-To: <20131028163333.GA4797@kroah.com>
References: <20131029013317.a33ae4ff86b88ea17bb58e74@canb.auug.org.au>
	<2bf73b4c-8905-4889-bdd1-6bdae2c54bbd@CH1EHSMHS036.ehs.local>
	<20131028163333.GA4797@kroah.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_18_04_02_+1100_/b8lvFT.ReI05eoY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_18_04_02_+1100_/b8lvFT.ReI05eoY
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 28 Oct 2013 09:33:33 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Oct 28, 2013 at 09:05:37AM -0700, S=C3=B6ren Brinkmann wrote:
> > On Tue, Oct 29, 2013 at 01:33:17AM +1100, Stephen Rothwell wrote:
> > >=20
> > > After merging the final tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > >=20
> > > drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_clk_notifier=
_cb':
> > > drivers/tty/serial/xilinx_uartps.c:436:7: error: 'PRE_RATE_CHANGE' un=
declared (first use in this function)
> > >   case PRE_RATE_CHANGE:
> > >        ^
> > > drivers/tty/serial/xilinx_uartps.c:436:7: note: each undeclared ident=
ifier is reported only once for each function it appears in
> > > drivers/tty/serial/xilinx_uartps.c:446:36: error: dereferencing point=
er to incomplete type
> > >    if (!xuartps_calc_baud_divs(ndata->new_rate, xuartps->baud,
> > >                                     ^
> > >=20
> > > Caused by commits in the tty tree.
> > >=20
> > > I have left this broken for today.
> >=20
> > I already sent a series to Greg which should fix the x86 build of the
> > tty tree. I think he didn't apply those patches yet.
>=20
> Yes, I have them, sorry, been traveling, will get to them later today...

As a temporary work around, I will disable xilinx_uartps in linux-next
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_18_04_02_+1100_/b8lvFT.ReI05eoY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSb13nAAoJEMDTa8Ir7ZwVha8QAIalVo62HIGWWl7CkhT+ji10
F/7p9vkspOeo+lsSSoih9Q/+Lae6E/br/YgHdgPlK/18BELjkrx8TkqcNIBoD6uR
+iYUq/sNe9f6FBN0Li8nFHNa2npIdXyi3ooBPcD/kIA6uoFAX9OiSEFrFDwQ9PTn
ogzOTPV55y3Ivmwd8y79da63uFB0LRSTj8BOYyDI73iOunDakQHsSURT+AKp+c+0
DD3/9n1mvvIkhU83oXVJMKdAogzHF6gL3OtdPiovT37mwPupG19OpchW3yOA8N0s
VGNzIHKV5jCsKAEzuBgaAGncO3mu8RQx9+fqVVWz0eb35lZ9Ea9+DD7RD2aF36ZG
yx3jH6a5rsvmX9zHcuwVkflUOfD10FsopMrDwGtyA5kgpjxKJ/f2dTVb1amBPCb5
4hvTrH0x6rRyzK8uQoKxZ4kVb0ohSrLeBDNhMhw6+JsY6pKkok7W+WaMbllaUJ9W
ydaC9wPlhqGQawBhjtqBZ5PpRjRIt5xWRmSxHHs3GHiCxa8/bPc1hdyPwC+WMgT+
yoiY2nl8CKzPglgsaEv3sKG1xXk3OQK3qjuclJVOhxtElFJpglzCa/K3a6dDjN7f
UMwc3pWGoFsEXoNblp8/WU2jbU+7B537jL24HJjV76pO9e45tv3gsNW8YcjEDI9D
aQ/DnMmsj7pvwoNe+RtR
=4l50
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_18_04_02_+1100_/b8lvFT.ReI05eoY--

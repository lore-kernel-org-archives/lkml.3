Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3CEKBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:01:23 -0500
Received: from mga03.intel.com ([143.182.124.21]:10552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab3CEKBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:01:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,786,1355126400"; 
   d="asc'?scan'208";a="208970833"
Message-ID: <1362477679.8626.13.camel@jtkirshe-mobl>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Jiri Slaby <jslaby@suse.cz>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>
Date: Tue, 05 Mar 2013 02:01:19 -0800
In-Reply-To: <5135BDF9.3080102@suse.cz>
References: <20130129202848.GE25415@pd.tnic>
	 <3066730.6MVSAfNyye@vostro.rjw.lan> <20130131131034.GF4926@pd.tnic>
	 <2293454.v8QRHr8txR@vostro.rjw.lan> <20130203144656.GB5844@pd.tnic>
	 <20130214143905.GC5700@pd.tnic>
	 <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>
	 <20130214191234.GH5700@pd.tnic> <511DF7B4.8060504@openvz.org>
	 <20130215091641.GA14387@pd.tnic> <20130304215056.GG22274@pd.tnic>
	 <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com>
	 <5135BDF9.3080102@suse.cz>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/06aT9dwB6OoIi78gIbq"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/06aT9dwB6OoIi78gIbq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-05 at 10:42 +0100, Jiri Slaby wrote:
> On 03/05/2013 01:16 AM, Bjorn Helgaas wrote:
> > [+cc e1000-devel, Jeff, Bruce]
> >=20
> > On Mon, Mar 4, 2013 at 2:50 PM, Borislav Petkov <bp@alien8.de> wrote:
> >> On Fri, Feb 15, 2013 at 10:16:41AM +0100, Borislav Petkov wrote:
> >>> So it looks Bjorn has taken most of them and the e1000e one will go
> >>> through the e1000e maintainers. I'll test after the merge window is
> >>> done.
> >>
> >> Issue still persists on 3.9-rc1 :-( :
> >>
> >> Mar  4 21:47:34 nazgul vmunix: [ 3223.412541] e1000e: eth0 NIC Link is=
 Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> >> Mar  4 21:47:34 nazgul vmunix: [ 3223.412554] e1000e 0000:00:19.0 eth0=
: 10/100 speed: disabling TSO
> >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034158] Uhhuh. NMI received for =
unknown reason 2c on CPU 0.
> >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034166] Do you have a strange po=
wer saving mode enabled?
> >> Mar  4 21:47:35 nazgul vmunix: [ 3224.034168] Dazed and confused, but =
trying to continue
> >=20
> > The e1000e changes didn't get merged, did they?  I don't see the
> > following changes mentioned at https://lkml.org/lkml/2013/2/4/185 in
> > 3.9-rc1:
> >=20
> >       e1000e: fix pci-device enable-counter balance
> >       e1000e: fix runtime power management transitions
> >       e1000e: fix accessing to suspended device
>=20
> You're right. They are not even in -next :(.
>=20

I have them in my queue for net, so I should be pushing them later this
week once validation has a chance to look at them.

--=-/06aT9dwB6OoIi78gIbq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRNcJvAAoJEOVv75VaS+3O0KwQAIlFOxG0XRugnfySWcOxiSAj
8QthHBfsGMtjrGnELpehrDAzuQjqMQl0053b5zHzue9pQkcbDRPkHQCfGcjXIU4J
b0l3E/8UnQa/1kL5ngrAt6a1q8hKZOs4v8Zwerv1sR0iEgTBgMRZ0R3ABwCKwJOp
g68MeLsMt4w618QwW1Id/k29fzkWauOiy7ichXx7l3Mbf6NMF5p03Ripy72S7ee5
UbJuy4VM4OQHFfeiVvvtpSdtOqxgjO3Ggjmzehfd/vpegqFmmlcKDfs/rCpdMw4h
4KuWzJixPxzMW9fuNTN6pQsoMny21wUTRTle9yb7BiPE0hL2zW1Pva/E89TPU3DW
Nw5BRvKm0zBGNHNF05Re32LQ05+Mk1wb6C9xL1hiax+Ur6osys6sO/NX/oys2ZVu
NwjJQ08pbX1/GQfczIBFkPhL5sOsXZ5KJu6vYnp70PWYc8WGANy/4UbdEeQ1b8Io
e/TerOdwbVA9T36WIa/YHmY16h6sUasyUTamxCSWd3J/+IAi9/Scqi5+9BXQhwgk
2xLKJfQuu0QrDKIjElx3ArjneTkMjbE46Z2/lxYhDVQuNDV3cXFWHEn/crIcY4BD
iuNtxWkJu2XN4xJRkNIdoivSyhkMItlUSg+u34Wrg6cHx1JBSh1HOV/n2MWBQe62
CB6OPW0HuuRPG/q2jjWt
=qPHr
-----END PGP SIGNATURE-----

--=-/06aT9dwB6OoIi78gIbq--


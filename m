Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbaISVIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:08:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51039 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728AbaISVIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:08:42 -0400
Date: Fri, 19 Sep 2014 16:08:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Take dwc2 driver through Felipe's tree?
Message-ID: <20140919210837.GH19560@saruman.home>
Reply-To: <balbi@ti.com>
References: <A2CA0424C0A6F04399FB9E1CD98E0304844D9D41@US01WEMBX2.internal.synopsys.com>
 <20140919210150.GA25927@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54u2kuW9sGWg/X+X"
Content-Disposition: inline
In-Reply-To: <20140919210150.GA25927@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--54u2kuW9sGWg/X+X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2014 at 02:01:50PM -0700, gregkh@linuxfoundation.org wrote:
> On Fri, Sep 19, 2014 at 08:52:07PM +0000, Paul Zimmerman wrote:
> > Hi Greg,
> >=20
> > How would you feel about Felipe taking the dwc2 driver into his tree?
> > There has been quite a bit of increased activity with dwc2 lately, and
> > I know you already have more than enough stuff on your plate already.
> > So this would mean one less thing for you to worry about. Plus it
> > would mean an extra layer of review before getting to you.
> >=20
> > I've already talked to Felipe about it, and he's fine with it. If
> > you're OK with it, I think I just need to send a patch adding a T:
> > line to the MAINTAINERS entry, showing Felipe's tree?
> >=20
> > I guess we would want to do this just before you close your USB tree,
> > and you could announce it then?
>=20
> No objection from me.  I'm working in my patch backlog right now, should
> get through them by the end of the day, so feel free to send me a
> MAINTAINERS patch I can use.

alright, it's all set now. Starting on v3.18-rc, I'll start taking dwc2
on my tree.

--=20
balbi

--54u2kuW9sGWg/X+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHJtVAAoJEIaOsuA1yqREJA0P/0avMEDvcoScrX2WfRbTlyk+
iUzfouvDvv5sFYzfg4z99zcmZrz4rGrmEMtwCpjzhbMPdv2KvTF6Go9B67z9ed6o
BrvHCT1E6MlmV+balmYanyehWVkZUdBlngbJ79kpXCSqhKOTlNNr2XUn5abmgH7z
CWYEcbncwxLQ79luq5mNC0PZjKK4DFvn1/yy7ATFKcNWjUIN0rk8JOaz30wM8hFF
NHxvqvQiKu6HJe4mx8NsEkjfzJPSz8/6/tIsjlwAS9TdzaqdT5C/EzJsSxKfU+fa
IztGUG6emAHMa3THLGgiJx5rUhlydADJJPcL8YFZdzc9n8PvsSuGvmcvyH3KXvxT
yZvXc5Lu0QUTfW+qwfgh/yqVCUib5k30wLY6JOdhmxw6d74kC7o/FNeo3p0LDG9h
g8Ghq53kAPTO+2gcGjOpHzr9mQU9wLCk/nbt+/n/sBrflPAjw1gExJOr981bNk84
+HRt++Nka0JAPUgw3R7mSz3ZPgOzzY5aMzVZ9A5qJWcrAgs2WfN3lYzA+nb2jK6C
hJZKPz0ISlk4sb9dyrehf3xjz9JHx2YvfpDHQK2pnA+vgfAW+4R1AbcNaznj4lzq
m+msDzTUb622sFGsRUY4R7mxeFkZrbeua2HgdRkwSunLdRqlTtWs+1VwXwwI7J+I
3T462AX0/CSh3dhdFU4/
=13Hb
-----END PGP SIGNATURE-----

--54u2kuW9sGWg/X+X--

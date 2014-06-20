Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbaFTIpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:45:15 -0400
Received: from sauhun.de ([89.238.76.85]:42436 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933833AbaFTIpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:45:12 -0400
Date: Fri, 20 Jun 2014 10:45:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/3] Remove devm_request_and_ioremap()
Message-ID: <20140620084506.GA2762@katana>
References: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
 <000c01cf8c30$613759d0$23a60d70$%han@samsung.com>
 <20140620025957.GA27387@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20140620025957.GA27387@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2014 at 07:59:57PM -0700, 'Greg Kroah-Hartman' wrote:
> On Fri, Jun 20, 2014 at 11:36:03AM +0900, Jingoo Han wrote:
> > On Friday, June 20, 2014 3:49 AM, Wolfram Sang wrote:
> > >=20
> > > Pretty much a year ago, Tushar cleaned up a lot of deprecated uses of
> > > devm_request_and_ioremap, yet some remains are still left. Remove the=
 last two
> > > users, and let the function rest in peace. I'd suggest that this seri=
es is
> > > picked up as a whole to have that case finally closed. Greg? Are you =
interested
> > > in picking it up?
> >=20
> > (+cc Greg Kroah-Hartman)
> >=20
> > I already sent the same patch as one single patch to Greg Kroah-Hartman=
=2E [1]
> > Also, it was accepted by Greg Kroah-Hartman. [2] Thank you.
> >=20
> > [1] https://lkml.org/lkml/2014/6/11/26
> > [2] https://lkml.org/lkml/2014/6/11/649
>=20
> Yeah, I'll go apply that right now while I'm remembering it :)

For the patch above:

Reviewed-by: Wolfram Sang <wsa@the-dreams.de>


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTo/SRAAoJEBQN5MwUoCm2Zk8P/A9k2dZa75Kwblws4jxjBp0R
l5RiqgVOAZuoYC+GjgBJHzaoiSs8OWWm1Jt3Qnq2Nvy62qqBzm+bGp2/v1vshkBP
ebXfcwCgD3vBinFw/Pn5IiBm13hhVsN1/HfFJN0Yc20A07ygdMo6FniIMLGpjbKg
S8CJ137iRVbuvS06eE3kxgfiCQVlwiu20MTYvUphlOVbrHbk4qt7R6qZrS7WBqBv
PfFXmSwYPunzYTF3zuswDw0QxDjKufXDoc4O1aCERepYj5Q5kxFKA7DKG7WQZxGp
bKl8zMm/hJbcjNI5371kU3pAglVUldAinfhW9TQluC+Uq2k6Des+acpAw2tTFKvm
LUZPev2zDXrO1zMFJOaKPcto75/TR4gBWsxrBglD76rdu860a9NS3dJImBsM1eVs
sVMCnlfAQd3Rt4p9nz8y0QKoarr5EwKvMlv1Gbk92ZLsD/hHycPkLGMiuhVoJmPC
QnBWuzdJ3TRYULAYNVM3FfRzrXhSYEzSUCPJnuJng3lMR5i+A9oTnJ/W2LKvP9Y3
lVDV9wifXtvUf2Q/kVSuz9n/XhGcwcQRrX4Ftt+3PUH74O8Jexy/lWz+nT291wua
ZYQpoJSzqg1Xq3biMhUYeCnoQLD59rEo0ztKpB68BJViXGosNAvkq0C93CyjO+7b
gqgj/rIlT0s2mZvyTE+m
=VohK
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--

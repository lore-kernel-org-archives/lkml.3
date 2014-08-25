Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaHYJjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:39:37 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40256 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaHYJjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:39:35 -0400
Date: Mon, 25 Aug 2014 11:39:32 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Holler <holler@ahsoftware.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140825093931.GB2399@ulmo>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
 <20140514141914.446F7C4153D@trevor.secretlab.ca>
 <20140821140211.GD19293@ulmo.nvidia.com>
 <53F64624.5000403@ahsoftware.de>
 <20140822131919.GX21734@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <20140822131919.GX21734@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 02:19:19PM +0100, Mark Rutland wrote:
> On Thu, Aug 21, 2014 at 08:19:00PM +0100, Alexander Holler wrote:
> > Am 21.08.2014 16:02, schrieb Thierry Reding:
> >=20
> > > Anyway, those are all fairly standard reasons for where deferred probe
> > > triggers, and since I do like deferred probe for it's simplicity and
> > > reliability I'd rather not try to work around it if boot time is all
> > > that people are concerned about.
> >=20
> > It's neither simple nor reliable. It's non deterministic brutforcing=20
> > while making it almost impossible to identify real errors.
>=20
> It's horrible, yes.
>=20
> > In my humble opinion the worst way to solve something. I'm pretty sure=
=20
> > if I would have suggest such a solution, the maintainer crowd would hav=
e=20
> > eaten me without cooking.
>=20
> We didn't have a better workable solution at the time.

You make it sound like we've come up with a better workable solution in
the meantime.

> Having a hack that got boards booting was considered better than not
> having them boot.
> I don't remember people being particularly enthralled by the idea.

Odd, I remember things quite differently.

Anyway, instead of going back and forth between "deferred probe is good"
and "deferred probe is bad", how about we do something useful now and
concentrate on how to make use of the information we have in DT with the
goal to reduce the number of cases where deferred probing is required?

Thierry

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+wRTAAoJEN0jrNd/PrOhAG0P/AkIFl+JHG9S1pSAEAq3sGuJ
sT+WVK+OS8lsWkXzPW8Cc19qL+mPjxeDsxPcno6LXtjPvcbMeQZkGry/67j1ucw1
aaELIJI5M+N3rtBlq0vytN0fWRPn3cOflPobnv1AHXVyaBGrHX8TR35yhXH2tgql
Hyou5Lq1uwLQPieejiUQ0PnAkpQlhDKrLrLvtjKDfvgIJxzHiq9jPO/k75bBCXmP
57b+J8oReBx+KLM/c5YEmsZCxp7qa0mXgwYKPxverTfcceawhmBBzDj1R2arzwxt
czBoAAFL1SXjpQKd7d2C+eMe6GAwwVtSyzapKondYFRPq8s5EHLc/4VhYj+t51Po
cTP+L/eH9GZc/xOh1UPFIB61JMPI+RIfCrAXMj0/P7XGsu09dxgQddpjxAEFYBz3
DAtKM5GDG9aMNHapIvlB1TxPUVMJzWV6m190kQvC+SJ/6unMib1b7knDtF9uTWBu
azU9FDRPl/jDXlGDeA2CzpT0MiN2o/lDZSw/q9pV2zSTjxovuc/C11a0sqhJfg9f
b52G4yXwjF9Do0En8zblF/Dwc9vWW5x0OQ9L8sElizb5wYEHx8wGJi9HVwp4O7kq
Yuwlx6XP35XbBqemkodMoDTwbfZ3pmDJBjTbeLED/2ME5d8LVXguJ1Scxi0/TZp8
exEO44cXMas0d2ZZxLri
=vwcO
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--

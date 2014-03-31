Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaCaTcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:32:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40508 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbaCaTcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:32:39 -0400
Message-ID: <1396294350.1241.45.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 118/200] PCI: Enable INTx if BIOS left them disabled
From: Ben Hutchings <ben@decadent.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Chris Cheng <chris.cheng@atrustcorp.com>
Date: Mon, 31 Mar 2014 20:32:30 +0100
In-Reply-To: <CAErSpo6KQNhh-4csydz7iZ+1WnX8LP+Hde8EN_oTwX=8bRAh2w@mail.gmail.com>
References: <lsq.1396221814.369444335@decadent.org.uk>
	 <lsq.1396221815.13737205@decadent.org.uk>
	 <CAErSpo6KQNhh-4csydz7iZ+1WnX8LP+Hde8EN_oTwX=8bRAh2w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VczO3k+dD0Cf5Q0FOK9I"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VczO3k+dD0Cf5Q0FOK9I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-03-31 at 11:15 -0600, Bjorn Helgaas wrote:
> On Sun, Mar 30, 2014 at 5:23 PM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > 3.2.56-rc1 review patch.  If anyone has any objections, please let me k=
now.
>=20
> No objection, but you need the followup patch as well:
>=20
> 3cdeb713dc66057b50682048c151eae07b186c42 PCI: Enable INTx in
> pci_reenable_device() only when MSI/MSI-X not enabled
[...]

I saw that follow-up go past earlier but didn't notice it was missing
from this set (which only includes cc'd patches up to -rc7).  I've added
it now, thanks.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-VczO3k+dD0Cf5Q0FOK9I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUznCzue/yOyVhhEJAQr+9hAAv0LsCLGXujT2Wi6C5jEEVUxsQGflhf2C
4lgmnEm4POfKL7SX4Vdi4hpQjgEwaxItBrnxlaStj5gB6/ngER9LH2Q2Opj4Iwco
2YP9WpSVPof0ylcIom8aj3CPeKFgTDfkQUIQ2CwHjVP4/5B5Rew+79lIEqmVBJBB
H/Oe0V3lK6dcaRcl20yUomXQaOmkkHbigbAt4tDgXa+dDo28UQM5QYdmcj/rdX7P
ASUNZlmxbFvLj0i84aagt0RUV9nuX18u7rXjgOIvHfxF7oID5uJN0RwZ4KG0qx7s
H8B5GSJ+vlEGUw1cqpT4XaZOriV1l7XMRUQRkd4KxNzr+2IcTKa+d/7KFzgL2HKS
8yft2Mp5R733JTN9IQ2dDy1TOKaIMrH35pCH+ygytv52+yeC0P8MNllidS6uymOH
BUIGipBBuXL77MYW233R+B+am5CglSrAdrQbGZDwnvR+2y8TEVw0Zmvhuef6iHwg
jXf/RJgxGjzQ3TjhaQANTnHPZzNTtqqnTQJuqxr9vbuV0HeM1Xd5+sdvv0v3zNG2
vPAqMqAu6cLZ32Uki8OvhSQ8RdL1o8mVpgaS4KGt2RTYPfCacAQ2UGcCx5FTimuL
2pvJ+v+sh/Zg+bQmiQ/L/1phOng3MY1TG/gjOGra2uIco4/RemRYGGnrdYlwNeOP
wmwX0KyWD0I=
=EzQG
-----END PGP SIGNATURE-----

--=-VczO3k+dD0Cf5Q0FOK9I--

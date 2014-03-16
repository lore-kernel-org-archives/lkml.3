Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaCPS5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 14:57:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46480 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487AbaCPS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 14:57:44 -0400
Message-ID: <1394996230.15764.113.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3/3] ath10k: add firmware files
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Sun, 16 Mar 2014 18:57:10 +0000
In-Reply-To: <CAB=NE6WW8yX4kdy02j2fT4g0JvYj4a_XkiqYtXKZSMB7FHuwNg@mail.gmail.com>
References: <20140314084501.23100.13103.stgit@x230>
	 <20140314084514.23100.72654.stgit@x230>
	 <CAB=NE6WW8yX4kdy02j2fT4g0JvYj4a_XkiqYtXKZSMB7FHuwNg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ANVEt/7OdFBiJ+ufZy8u"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:2147:ecc:c25a:bcb5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ANVEt/7OdFBiJ+ufZy8u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-03-14 at 05:36 -0700, Luis R. Rodriguez wrote:
> On Fri, Mar 14, 2014 at 1:45 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrot=
e:
[...]
> > + NO LICENSES OR OTHER RIGHTS,
> > +WHETHER EXPRESS, IMPLIED, BASED ON ESTOPPEL OR OTHERWISE, ARE GRANTED
> > +TO ANY PARTY'S PATENTS, PATENT APPLICATIONS, OR PATENTABLE INVENTIONS
> > +BY VIRTUE OF THIS LICENSE OR THE DELIVERY OR PROVISION BY QUALCOMM
> > +ATHEROS, INC. OF THE SOFTWARE.
>=20
> This -- however is new to linux-firmware -- and I hereby raise a big
> red fucking flag. All other licenses on linux-firmware provide at the
> very least a limited patent grant. What makes Qualcomm special ?
[...]

There are several licence texts that don't mention patents at all.  I'm
assuming that the companies submitting firmware for inclusion in Linux
or linux-firmware do intend to grant whatever licences are required to
distribute it to end users.

Several licence texts explicitly exclude patent licences relating to any
*other* products of the same company, but that's quite redundant.

However this language seems to explicitly exclude *any* patent licence.
You're right to raise a red flag because, assuming Qualcomm does have
patents that cover the firmware alone, this seems to disallow
redistribution in whatever jurisdictions those patents apply.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-ANVEt/7OdFBiJ+ufZy8u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUyX0Bue/yOyVhhEJAQpPeQ/8D6Z1UqLY4JPQsVWUWUMd/9CMVO3pBIK8
m8+yo0qgC8WL7CWHe8kPDkL05gNPdj5ef7qc+AzqYTKEvaa4pTbQ6BS8Y14FhTVS
cUo4fDjhJfT9R7uP7XBtCGagcaOUzFoDvYgMlH+pN2qeoV+v+IkxXTadTRsfpY5x
oLHklcoFTrwf02VLba77eNsEzKHciOG9go3rJVXn/wgwCYdBCCNhzwpmfZJQzPZm
AwNFshs2ndQI7yVlU+zT/hSdEgpOj2Q20rZxFVVTQSxRd2J5NKvaqXu1vkSlDkGh
m0uUCsluIHSt1VUK0RSBaJ/pIG/NatimdSCpH1V4ohREGAO5u3K7N/FUFcJk0apO
3keexu3nJ40hkxyArPzL8mYNJb0mJ63cvAkkCyf6a5xECXJV24byG/5pvdSrLTkf
M1pI9nQvQYRMN8YQTocNBiw3L8oQF/jEpabZKluHqy3Cayvnj+EluDhXOsbtcg/x
ufhcViPr5xsyyTimkhcEVPPNKyPNdzXccRO7w5Ee6uN8mPrxlSHEShV4mnOdSGWH
T2r4Y3ms2uTmmTDk2JNrDtengTg1qM8+B6dODOB7wR02j2bO7O2D8yei8dVm7SMG
IVT4iJ0M9rv8jKrC/lTXG+EmfLaFKr4fOTe5jqTM2Gn8racr/hjvT2ywbV4wwdYq
BYuxxRlkn6w=
=r1Jd
-----END PGP SIGNATURE-----

--=-ANVEt/7OdFBiJ+ufZy8u--

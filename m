Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412Ab3BLEkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:40:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59788 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3BLEkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:40:22 -0500
Date: Tue, 12 Feb 2013 15:40:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        <linux-sh@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] Centralise CONFIG_ARCH_NO_VIRT_TO_BUS
Message-Id: <20130212154010.3f8b88da4756c7cf04e28a04@canb.auug.org.au>
In-Reply-To: <5118DCA8.1030905@imgtec.com>
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
	<CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
	<20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
	<5118DCA8.1030905@imgtec.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Feb_2013_15_40_10_+1100_/tP3R2cmcOMVcqGq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2013_15_40_10_+1100_/tP3R2cmcOMVcqGq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 11 Feb 2013 11:57:28 +0000 James Hogan <james.hogan@imgtec.com> wro=
te:
>
> On 12/11/12 21:26, Stephen Rothwell wrote:
> > Make if easier for more architectures to select it and thus disable
> > drivers that use virt_to_bus().
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>=20
> I was just wondering what the status of this patch is? It was in -next
> for a while but seems to have disappeared.

Yeah, I think Andrew dropped it in favour of a more complete solution
which I haven't written yet.   Let me dig out the emails and have a shot.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Feb_2013_15_40_10_+1100_/tP3R2cmcOMVcqGq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGceqAAoJEECxmPOUX5FEFmMP/0Ij7tkBNzHsx4SV440XKPZA
D1dk7h3RiqyQnN6PR3EXOyRq8bqAOZvo45qor94ToZjleK8c2/qJP1cPlhJ4FQg1
d8tQ/0ZElEnpwfAXTL20FZL38vz3OivQWW4Bg/NR8eIMK1HXkQWSjTeAQEYXY+4a
ImIHecJd5bigDctCIuBnSgur9Ojso/sUHnk6vlin5pW5PjYeEucGoYPjjP84MY+6
L8KbTarTQdLwS3U2mNmpnuJYjLcykJqrmjj+RP6O6qUmcSE5/Gc8KnrPWIMEQ7Yq
QGijkjTJcoAoDTZ/lv0hY5UDFoqFFvjBnLmmcbpdzK0WfB46jP0WRz7pfatvxfP1
/QwGED65JR5nuwMmD2KVIJwF/X4jv8f+qi/yMFk3xvFESLx4MJwVESU5N/VjH091
Fo3xjohM+YzujERv7CGLTT5ncgQHaxi/7KpynIOfIUEOiAAgZH/v2Z6kYSR7hfVS
vjXmTicgCv6/5B2lSQ3bstq0uOD0dS2H9KLw42V3zvqJNXkMR4R/uPoefKyVENTt
8kReuHcDAa/bfBuTCdzn97xH3sxYxs/QCMNlJHdeH41Hya4KEtR4Q4sa2O2/zg2Z
upTJ/uRiJnzQ4UW6XNPPPXpnD3eq+y/PrtDmCcJvHy1S9i4U14ztqgYqy0WKlJWt
28ClCvTZEJqz7XzYWvNm
=9W1/
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2013_15_40_10_+1100_/tP3R2cmcOMVcqGq--

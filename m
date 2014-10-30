Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbaJ3OJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:09:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45916 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760326AbaJ3OJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:09:09 -0400
Date: Thu, 30 Oct 2014 09:08:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 01/20] usb: dwc3: enable hibernation if to be supported
Message-ID: <20141030140832.GH6482@saruman>
Reply-To: <balbi@ti.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-2-git-send-email-ray.huang@amd.com>
 <4077930.b7qzaS4pBb@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1xGqyAVbSpAWs5A"
Content-Disposition: inline
In-Reply-To: <4077930.b7qzaS4pBb@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X1xGqyAVbSpAWs5A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 12:35:56PM +0100, Arnd Bergmann wrote:
> On Thursday 30 October 2014 18:08:26 Huang Rui wrote:
> > It enables hibernation if the function is set in coreConsultant.
> >=20
> > Suggested-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> >=20
>=20
> Something went wrong with the Signed-off-by lines here.=20
> You should never add someone else's Signed-off-by below yours.
>=20
> I took a brief look at the entire series and the patches all look good
> to me, but you have made the same mistake with the Signed-off-by
> multiple times.

there are no mistakes, I just asked Huang to resend what I had on my
testing/next because it had not been sent to devicetree mailing list.

--=20
balbi

--X1xGqyAVbSpAWs5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUkZgAAoJEIaOsuA1yqREgMMQAKMXQfr0PWErwr7WmC0dOSOi
9UauOEaMI/MzTxBDSVqsjdKjmtyk41QUFucSWxaRcQELyCmgLef5//wj0zS0ucqP
X0Bu7rL/NAuQSRfXq+ZYfBjjWDtCdTMijlELjoMKhQqyaydZkHFuiHsModh3XjJb
GJ65WigMBLdKXBOVZp9si1FpwkcdOPFnMrPwyiUrVEoDlG1yTyiXUl+QfZFagfjw
a/osgH0HJ4lgq53D19VPTj5Ybz7Cxv0ba0crdIcebKFN9yoRu8jSLf/u8y9uRSnk
GdlIYWOivrIx/HtT64B5mjWhXtaS+9eQTKs4Xm9A1Rj4ZvvgTknwtYlPp8FKzXqs
gjaaMTKESVRn3V5o7pgtj2jg7AORvQs0eE8gDBMqoMAxyHjn7Sf3xHNIum+Kscau
fvV+XBK123eX64P7Rzky60fZZXwtp7MTd0m1eAVUsGbz3JuCzGvJOe6z1+EVc/n4
hSPf6BQQDxzwkSrZLXz6Ey//fAqgNoLzQ6smYQBNYIoqfGLgmDW3a8PfkERda/qJ
bc9dvjA7iFNB/xMUx3/fTRlq8cMMaFE50s0tkh17vA7K9w2KFQP8+a8mGwlpoJ4I
x158x/QWVYNESdrrnA4P08T5fWo31BDTI/jwDmyNeZtAi+Dg99Zm97ViwidIBsZK
J6sE8O4FvE4PF2ZR69EY
=hiSZ
-----END PGP SIGNATURE-----

--X1xGqyAVbSpAWs5A--

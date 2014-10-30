Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbaJ3OTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:19:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46391 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759180AbaJ3OTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:19:31 -0400
Date: Thu, 30 Oct 2014 09:18:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <balbi@ti.com>, Huang Rui <ray.huang@amd.com>,
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
Message-ID: <20141030141857.GJ6482@saruman>
Reply-To: <balbi@ti.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <4077930.b7qzaS4pBb@wuerfel>
 <20141030140832.GH6482@saruman>
 <2025342.7A7Ashtuyx@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cDtQGJ/EJIRf/Cpq"
Content-Disposition: inline
In-Reply-To: <2025342.7A7Ashtuyx@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cDtQGJ/EJIRf/Cpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 03:14:17PM +0100, Arnd Bergmann wrote:
> On Thursday 30 October 2014 09:08:32 Felipe Balbi wrote:
> > On Thu, Oct 30, 2014 at 12:35:56PM +0100, Arnd Bergmann wrote:
> > > On Thursday 30 October 2014 18:08:26 Huang Rui wrote:
> > > > It enables hibernation if the function is set in coreConsultant.
> > > >=20
> > > > Suggested-by: Felipe Balbi <balbi@ti.com>
> > > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > >=20
> > >=20
> > > Something went wrong with the Signed-off-by lines here.=20
> > > You should never add someone else's Signed-off-by below yours.
> > >=20
> > > I took a brief look at the entire series and the patches all look good
> > > to me, but you have made the same mistake with the Signed-off-by
> > > multiple times.
> >=20
> > there are no mistakes, I just asked Huang to resend what I had on my
> > testing/next because it had not been sent to devicetree mailing list.
> >=20
>=20
> It's definitely a tricky question what the right Signed-off-by
> chain is in this case, I guess strictly speaking it could have
> been=20
>=20
> Suggested-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
>=20
> which could correctly track where the patches went, but it's also
> somewhat silly.

somewhat ? You don't need to be so black and white.

--=20
balbi

--cDtQGJ/EJIRf/Cpq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUkjRAAoJEIaOsuA1yqREjk8P/1ZrLRuZqVFKhnwUAAE3ZVzA
5QsPgWItY6dIvCRDESvI0y4QMJGJZ/IZqtcgH3D86hjLIoGntQJicuUCeiEniwXR
Z94v9U8CjaZuUUB78pdXtzmgWuykw9yyVdhKNHTz4hS2azpG8nMl1AFgYOiCMjub
a+9cLLKs/Eov3YLGwfet5mShMgrnb/2SG/JgHafL6E/jIieaISFcRfEq5Sn6r7Gi
iEFj2sdNsjilOYnL+MdoL6aBn6h0Q/NnUY7ao6s+Mw1+3G/NCQ8+QYxLDQ6fP02p
h2RSmy+R7w8bNRFK3hj0cx/qSX5jdSkLtdb4EbszJZIfWSlWNWsy4RRE2Nd/QwmE
0my/nOMfy1QHSK8dgwb+PKpuNlAKXeKpg6Z+Zjm+R1xwFPIzwZennR0LRHWgYjT6
n9G2A4XOww9yOIQnSVymsTbU+AneyDAnmic4wu5XgR6uOM6hvE9BGCDyRNOpwktk
dQMgR1QSIQRwFxJevv+IsMWfyqwHawBBZHmtjx7E7+bQtoxXC2rGNhpn5SUrTWVx
KWI7pG65Y5Y/yQHVLIjkf8IsgBaIanYhYCVMQiLYp90uSCGUzaQ+dgTWRSuU1SB6
egA4m98N31hJzZ2gctduFYtCHPSurzhVSG0NceR5YGs2E5lAUSVhHBCE00e0oULm
jCA0LeYb4AFee/QGEPlr
=mF9r
-----END PGP SIGNATURE-----

--cDtQGJ/EJIRf/Cpq--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaJ1PYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:24:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50278 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaJ1PYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:24:31 -0400
Date: Tue, 28 Oct 2014 10:23:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/19] usb: dwc3: add support for AMD Nolan SoC
Message-ID: <20141028152359.GF8123@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <20141028144156.GC8123@saruman>
 <20141028151715.GB4519@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WlEyl6ow+jlIgNUh"
Content-Disposition: inline
In-Reply-To: <20141028151715.GB4519@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WlEyl6ow+jlIgNUh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 11:17:16PM +0800, Huang Rui wrote:
> On Tue, Oct 28, 2014 at 09:41:56AM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Oct 28, 2014 at 07:54:21PM +0800, Huang Rui wrote:
> > > Hi,
> > >=20
> > > The series of patches add AMD Nolan (NL) SoC support for DesignWare U=
SB3
> > > OTG IP with PCI bus glue layer. This controller supported hibernation=
, LPM
> > > erratum and used the 2.80a IP version and amd own phy. Current
> > > implementation support both simulation and SoC platform. And already =
tested
> > > with gadget zero and msc tool. It works well on file storage gadget.
> > >=20
> > >=20
> > > These patches are generated on balbi/testing/next
> > >=20
> > > Changes from v2 -> v3
> > > - Confirmed these quirks will be needed in product level
> > > - Move AMD configuration patch to the last one with all quirk flags
> > > - Make all quirks as 1-bit field instead of single-bits on a 32-bit
> > >   variable
> > > - Add all quirks DeviceTree counterparts
> > > - Make LPM erratum configurable
> > > - Add PCI ID into pci_ids.h because it will be used both on PCI and D=
WC3
> > >   device driver.
> > >=20
> > > Changes from v1 -> v2
> > > - Remove dual role function temporarily
> > > - Add pci quirk to avoid to bind with xhci driver
> > > - Distinguish between simulation board and soc
> > > - Break down all the special quirks
> >=20
> > In all patches touching DeviceTree, you should add the matching binding
> > documentation under Documentation/devicetree/bindings/usb/dwc3.txt
> >=20
>=20
> OK, will add this documentation.
>=20
> > There are still a few cases where you're clipping words too harshly, for
> > example tx_deemph doesn't look very intuitive, if you spell it out as
> > tx_deemphasis, it's easier to read. Remember that humans will be the
> > ones fiddling with those quirks.
> >=20
> > A few of your patches I have fixed myself and they now sit on
> > testing/next, please rebase your remaining changes there and make sure
> > to add DeviceTree documentation.
> >=20
> > When resending, please resend the entire series (even the ones I have
> > already taken) because you also didn't Cc devicetree mailing list.
> >=20
>=20
> Got it, could I also Cc stable mailing list and make them back port to
> stable trees?

there are no bug fixes, are there ? Please read
Documentation/stable_kernel_rules.txt

--=20
balbi

--WlEyl6ow+jlIgNUh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT7UPAAoJEIaOsuA1yqREtlwQAKzNh7jEzmEQ4UkfKf8ItfKu
u9rHDh6+T3Amzntz8Aa+VFeXSl2Eg3tbxAe9KtqC5VRSXjK2oNIxtos2T1p1Eg1h
EKV9mLEOlWvzgg+2oYbPx2j9PtGSavA5edtMhK23xfDGgsmuo/53tYamQJGE7xGg
mjkkmGcCUVvwrUjpWphx6akR9UqUccvz0D/orShXCQCrrLAbRIeSnHNaCh86wLXX
aorgv/ZNSg5PayOtigQNyaUFKbTQ+srpcpZicQmck4hQUMx3LbYxrsK3ENxWtogr
3kU36oGM9YjxaxOEeQ/NWhcIZM+/4QHgfY3PCa+cfl6fGRr6TSvOqEu5XkfrBbW7
A2HH46HIe1J751fdZLr1QZEnk0qRWZYt+h/F1rtLqNzZkMvhuKGYK5GPzRo7dz3W
KbfMoGKwZZF0mpHWZ+/3OM6AvsLVziKiJQ3EroonOpClOAhFpNAV2K3s9Y28Dlt/
6cIGsCYzjk0JLtaui6S/Ek+RHihuVcSFaGwxVhr1VAi1XCmYFalnMCijIQgO+buP
89XeHCwBR2r9/kZR7qo10IB08iBwkPKWaTyXKgzdmIj9PRCTnFBuX5PspMnaCdQS
6K54CY/zir8OAgKCcxNKZPJtN1kgSEyjFYIqDVjcQjGJrqdmUDk4NumObqbZb0Xk
euAk9xA8EjdLV4glbdUs
=X2NL
-----END PGP SIGNATURE-----

--WlEyl6ow+jlIgNUh--

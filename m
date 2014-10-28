Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaJ1Om2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:42:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56567 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaJ1Om0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:42:26 -0400
Date: Tue, 28 Oct 2014 09:41:56 -0500
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
Message-ID: <20141028144156.GC8123@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 07:54:21PM +0800, Huang Rui wrote:
> Hi,
>=20
> The series of patches add AMD Nolan (NL) SoC support for DesignWare USB3
> OTG IP with PCI bus glue layer. This controller supported hibernation, LPM
> erratum and used the 2.80a IP version and amd own phy. Current
> implementation support both simulation and SoC platform. And already test=
ed
> with gadget zero and msc tool. It works well on file storage gadget.
>=20
>=20
> These patches are generated on balbi/testing/next
>=20
> Changes from v2 -> v3
> - Confirmed these quirks will be needed in product level
> - Move AMD configuration patch to the last one with all quirk flags
> - Make all quirks as 1-bit field instead of single-bits on a 32-bit
>   variable
> - Add all quirks DeviceTree counterparts
> - Make LPM erratum configurable
> - Add PCI ID into pci_ids.h because it will be used both on PCI and DWC3
>   device driver.
>=20
> Changes from v1 -> v2
> - Remove dual role function temporarily
> - Add pci quirk to avoid to bind with xhci driver
> - Distinguish between simulation board and soc
> - Break down all the special quirks

In all patches touching DeviceTree, you should add the matching binding
documentation under Documentation/devicetree/bindings/usb/dwc3.txt

There are still a few cases where you're clipping words too harshly, for
example tx_deemph doesn't look very intuitive, if you spell it out as
tx_deemphasis, it's easier to read. Remember that humans will be the
ones fiddling with those quirks.

A few of your patches I have fixed myself and they now sit on
testing/next, please rebase your remaining changes there and make sure
to add DeviceTree documentation.

When resending, please resend the entire series (even the ones I have
already taken) because you also didn't Cc devicetree mailing list.

cheers

--=20
balbi

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT6s0AAoJEIaOsuA1yqRE7NYP/RVFFlxbqfvKIz6ZUVBkaTK5
ZXtyzVYuL95XOy95g9UDtkf51BQmeVNPdHJ8B2kDZhaS1tNU5JPVsK2B+lFGIoQf
e1Vomi5RS7F2MdJ4yE0xaq/Bq1HG37S+sescEXgab3fO209aUAW9jNuliURpAe0I
zhZWNJzoi9vIFnyb943sb8ytiQWp4pYTSRKRn16or9y0eSzEKgMioyaAH4aerSr/
ZpBYKYPFIbI9N91aKpoAx2P4H2TlYtziWXmwiReCSwO99yH7qpFpvNAA0T4i2UNI
VbDARH9pm26YwYPjW0FI+vpvCFMdEVA0AkeQpDK/3jegcK0oh8H31g2hsZ/XRGBf
XqCyn47q6GaJz1HqXx6NiAiUNO11zcMTFHkWKUbLBZZ3Ge+E6Myyz8AzlvTjVeC9
hMQxqzZDgP3LZ/XP//Bxs0Rf9UUbG4aDgESzYrHZVuJlf0hfOph+ewDhKcAWYkhk
Fbq2ZG1Na9VDIF1H4zpqgSFq1lVbn0vFp/2Fd9DKtpYp4EZOfmHeMHC6rkXNDuIc
PgJLbLzBcjumC/iZL+e5ZQpEp6FkUPU84XJ/HLKf9meZqQVOx06mRtYB+Drn3/+z
893A7YHTLa/wq8K0zXQWU/U8ZSJpcTAdXubvQ0t0KxS/hXWt5OZ2EcaI9h27VaVG
Ybu/W38cTeKMl1y+aXbq
=u9vT
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--

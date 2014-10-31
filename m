Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbaJaDAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:00:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32986 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaJaDAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:00:43 -0400
Date: Thu, 30 Oct 2014 22:00:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 14/20] usb: dwc3: add Tx de-emphasis quirk
Message-ID: <20141031030010.GB1080@saruman>
Reply-To: <balbi@ti.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-15-git-send-email-ray.huang@amd.com>
 <20141030164210.GM10130@saruman>
 <20141031012954.GA20367@hr-slim.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <20141031012954.GA20367@hr-slim.amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 31, 2014 at 09:29:55AM +0800, Huang Rui wrote:
> On Thu, Oct 30, 2014 at 11:42:10AM -0500, Felipe Balbi wrote:
> > On Thu, Oct 30, 2014 at 06:08:39PM +0800, Huang Rui wrote:
> > > This patch adds Tx de-emphasis quirk, and the Tx de-emphasis value is
> > > configurable according to PIPE3 specification.
> > >=20
> > > Value		Description
> > > 0		-6dB de-emphasis
> > > 1		-3.5dB de-emphasis
> > > 2		No de-emphasis
> > > 3		Reserved
> > >=20
> > > It can be configured on DT or platform data.
> > >=20
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> >=20
> > doesn't apply:
> >=20
> > checking file Documentation/devicetree/bindings/usb/dwc3.txt
> > checking file drivers/usb/dwc3/core.c
> > Hunk #2 succeeded at 718 (offset -2 lines).
> > Hunk #3 succeeded at 777 (offset -2 lines).
> > Hunk #4 succeeded at 807 (offset -2 lines).
> > Hunk #5 succeeded at 829 (offset -2 lines).
> > Hunk #6 succeeded at 840 (offset -2 lines).
> > checking file drivers/usb/dwc3/core.h
> > Hunk #2 FAILED at 697.
> > 1 out of 3 hunks FAILED
> > checking file drivers/usb/dwc3/platform_data.h
> >=20
> > please rebase on testing/next
> >=20
>=20
> That's because in patch 12 and other ones you applied, I changed
> addreviations to uppercase such as "lfps" -> "LFPS", "fpga" -> "FPGA".

didn't notice that. I'll just reapply the entire series.

> Previous 13 patches are already applied. Do you mean, I send the other
> patches since "Tx de-emphasis" (patch 14) after rebased current
> branch.
>=20
> If yes, at patch 1, "Enabling this bit ... hibernation .. yet", should
> it be updated in extra patch?

don't worry, I'll reapply the whole series, thanks :-)

--=20
balbi

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUvs6AAoJEIaOsuA1yqREZ5gP/0O2Awqolw+xdH0HB0yJ2Ys1
EKNq8PEYrXazHL65nCQYeTlHm2yjqQoVk9fs6sFcBHuda5TUQqr5VS4MiDepNvge
YD0KDRD27fwjaWvZ317R7uoPu3T8ovDZSsRTrUtmfhmgJ+J6BDTsKbgWLaIS2NYf
NNuU5kxr2GS1hHp3egR54tK9AK5JptmsI7wNg7Nex5Pzsy1MpDCdHeoT40leg5N5
F9Li4m+0EBapmxjZMfTRPIVFkF8JvpRhq5GeQsM/0P6vkvf3jsrhXKqQQ4+UjjMA
0FCUuHbyXKYiZ0hBQOYPfQGJ3AJqEcnB0K/kZMTpU7WkjUQPtCtAxTl545nisT3X
XiJviKKsVMzw1GD6FEZmuy8M4NfzDHrxpenzi3hHsi5aEaTnsCGdzmVRXfrClY3S
X6uHT4ZROWPA1lpyvR8O5kLqQC/fSqj2UA/mTJdovdUTBwXApEQ7pC14E0Nvjvof
uyk9H2IN9tC2vBB0/8eRJCN5Ni5E8cKxm+ZbF23VDv2pjPKNDAZVAzqTC/ms4iZF
O07XbTam3nvh0tj/g7szQ5k6eo277CzK1ULOCQFD9x4PnUDNCcNCP4eHW9Veag4/
WYDG/pN1JgUK7thIM2x1yJAGyUzMWpLh8oUx1WrER1PZ/+bBTy78FLha2IUZY7zb
dMhny++MnxkXrTmTbJHz
=U9H7
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--

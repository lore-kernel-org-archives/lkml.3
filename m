Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbaJ3Qmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:42:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53368 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758966AbaJ3Qmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:42:40 -0400
Date: Thu, 30 Oct 2014 11:42:10 -0500
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
Message-ID: <20141030164210.GM10130@saruman>
Reply-To: <balbi@ti.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-15-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kK1uqZGE6pgsGNyR"
Content-Disposition: inline
In-Reply-To: <1414663725-2195-15-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 06:08:39PM +0800, Huang Rui wrote:
> This patch adds Tx de-emphasis quirk, and the Tx de-emphasis value is
> configurable according to PIPE3 specification.
>=20
> Value		Description
> 0		-6dB de-emphasis
> 1		-3.5dB de-emphasis
> 2		No de-emphasis
> 3		Reserved
>=20
> It can be configured on DT or platform data.
>=20
> Signed-off-by: Huang Rui <ray.huang@amd.com>

doesn't apply:

checking file Documentation/devicetree/bindings/usb/dwc3.txt
checking file drivers/usb/dwc3/core.c
Hunk #2 succeeded at 718 (offset -2 lines).
Hunk #3 succeeded at 777 (offset -2 lines).
Hunk #4 succeeded at 807 (offset -2 lines).
Hunk #5 succeeded at 829 (offset -2 lines).
Hunk #6 succeeded at 840 (offset -2 lines).
checking file drivers/usb/dwc3/core.h
Hunk #2 FAILED at 697.
1 out of 3 hunks FAILED
checking file drivers/usb/dwc3/platform_data.h

please rebase on testing/next

--=20
balbi

--kK1uqZGE6pgsGNyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUmpiAAoJEIaOsuA1yqREJQEP/R+XsYU79Wlt3oZgaoBt76uB
wkfYTqMEwT+Dqks40b0qKBZdCvrKdj9GmqyN2BD2ou2KRuqZkvBwKKDbQIb6BWXz
5x5ylIgg+3jJu7DmWNyV9afjBPX3pRy/Eex38zSUL9BMDn84m4kZLZFb/oFQQiR6
aW3W1sJ4pOcW+TzyfUGY+8JaY2yTYd+67p/e1gNtnVIy8/+MTq9824vsUG8fMrqI
E13zlEmpyFX/mne2iwVrU6Q1PCtYErUTPdRuOCl+EnwLHADMXPtRNBE6ulNKZ8Un
iVvZTGX4V2ymLuuxJBmRHKE535Gxy3mJ2iKc7kn82DQCNaXGXhxCH/UwhtEprw5X
BlRldJAqvyYn1I3hPph0ZxkJdrHYt5FuHS3KRQh446CyNBfP5I9EjpTtY6ftszc2
phBGMUUQnI8TyiABjCp6E7j9+SqFEw7yom2lSJIRCuNICO8KTjm78ZtL8W9Fb1lW
hLjAYFo0s+r/03WcAsxFWvJNP57ihCu7AN7lQXD9Z13j52izMHGFHQmsg2ejHj8N
vHW3kneMQ/tyW7XF1QFwkdvi2BonoEfcuXspumQkHs6UVdUUKXZrkp7liMWqS89b
DmlefY+Y0sPU9aeoJKRoAaj5S8LfbSl2oiPlJo4bALeTTveABbxFYCA3G8PCDZW9
FC4tAH2hPths+v+iXjdW
=x5G4
-----END PGP SIGNATURE-----

--kK1uqZGE6pgsGNyR--

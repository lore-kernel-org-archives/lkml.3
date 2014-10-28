Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaJ1Smq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:42:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39246 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaJ1Smp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:42:45 -0400
Date: Tue, 28 Oct 2014 13:42:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/19] usb: dwc3: add disscramble quirk
Message-ID: <20141028184213.GC25735@saruman>
Reply-To: <balbi@ti.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-5-git-send-email-ray.huang@amd.com>
 <CAErSpo5vRcGxu=e61tCEwNVL913_Lxne=1KW+JtQVpc6jgCaHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <CAErSpo5vRcGxu=e61tCEwNVL913_Lxne=1KW+JtQVpc6jgCaHg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 28, 2014 at 10:39:26AM -0600, Bjorn Helgaas wrote:
> On Tue, Oct 28, 2014 at 5:54 AM, Huang Rui <ray.huang@amd.com> wrote:
> > This patch adds disscramble quirk, and it only needs to be enabled at f=
pga
>=20
> "disscramble" (in subject and above) is not a real word.
>=20
> I see that DWC3_GCTL_DISSCRAMBLE is already defined in
> drivers/usb/dwc3/core.h even before your patches, so I suppose it's
> something the hardware designers made up.

hehe, disable scramble :-)

--=20
balbi

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUT+OFAAoJEIaOsuA1yqREl9oP/1R2h7m49fmZriFB6u9g8bpS
qTazfs/gKQC+8rXTCuKyQI1xLC2BxMNhmlbbndoTrQ4v+zV3RpBQ12tkq89fI7QW
rjK7wNOcPiqxSgwur/teRbTY/XKPU3IFDeG1Oe5c5N5h8/nCw8xcj3ncUzAfILDz
dE/jTyjTMczOMBoLzIr6TUb1Cc3L3Tir50iN7BI1iYjCYCasWkt7cnweqs6scr6d
HTahz6xrek+7cAVdcywzQQNPzs5fo7ogeAgr3Z6d8cUGY4qHUEqhHPIcuC5xooxS
UHFpo2P+J7BzzECfTh4ubo6iVX9TlKc2GY5bth6hagG/+tr/BPCjTZjtYzX6kZPX
iej5ia4hlOydAdxV2SjdCODdRzEX0qeqoYHSK3WYi8eooV9LBPu1FlevdZKPOlsO
RFUYeIu3d63UDjIAJQ5+fujnQkEqbqjcfCXtoH+ABsD2c6C3ce2Xlq9XBTV55OFh
X+a125Eb3QAiTfKTS8JuIfeTM4/Zs0W01JV+CZox1T8DoZdnAk8VtiLVk+vEg0z8
u61SUCwqei47T8JP7bU+QX6hrLTq3UjLx5JzEwlfxC/Ui4oq33xnyqWDq56tYoHo
l5SUTTORi53JYutL5Z+G/644yzFeRMhZR5zHgtah+TZanstT3iFKDpSi/f1i4PJo
IlhGi0wSDgQ5gKjDLHLA
=wKXT
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--

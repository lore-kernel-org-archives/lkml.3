Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbbASUBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:01:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50051 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbbASUBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:01:20 -0500
Date: Mon, 19 Jan 2015 14:00:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: John Youn <John.Youn@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>, Sneeker Yeh <sneeker.yeh@gmail.com>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH v2 2/5] usb: dwc3: add revision number DWC3_REVISION_300A
Message-ID: <20150119200005.GP20386@saruman>
Reply-To: <balbi@ti.com>
References: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1421654209-6486-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <20150119144642.GD20386@saruman>
 <2B3535C5ECE8B5419E3ECBE3007729090174814C4D@us01wembx1.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LW0Rr0Uq98qh6Rv"
Content-Disposition: inline
In-Reply-To: <2B3535C5ECE8B5419E3ECBE3007729090174814C4D@us01wembx1.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1LW0Rr0Uq98qh6Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2015 at 07:45:31PM +0000, John Youn wrote:
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Monday, January 19, 2015 6:47 AM
> > =09
> > looking at Synopsys Solvnet for this IP, it shows that current version
> > is 2.90a. There's no 3.00a. Paul, John, is there a 3.00a version of the
> > DWC USB3 IP ?
>=20
> Yes there is, but it has not been released yet, thus it's not in Solvnet.

alright, in that case, Sneeker, can you update this patch to add 2.90a
and 3.00a macros ?

Thanks

--=20
balbi

--1LW0Rr0Uq98qh6Rv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvWJFAAoJEIaOsuA1yqREmfoP/3wjs5yS5hXLHKZAr+OfVNj9
IefA2Y0gNvM7KDUmT506nJH8A5Q3k5knlmBAkh6tJBezhqlweimc5E36I3uHQaWr
XDDHrcJMTpTbyf4iRCeDR9BzcJYW2x1WMEZQw+pEj13SplnsSp94MiieBVvkXGHl
mH6ZMWBJilSlhrCI6fTfqWwLc+/lRa/HRhbLK+IrwGS3/ks/w2lNpuZF9GcG0mCK
tYGuKhkUMLjATBK1NBChaKTmruEqToWhRtbu4Bho5Gksxxt/fPFMM7Wm8Vpr178d
w9Cbj8c5B5Ql2yXrRccmW9AaUHOSZHLNxMzQO3wKJtR+1nts/+SkcOMeB+wzrl7Z
DZltoDNVgO18LcVbIhRqJtprWZ4+4jDz77e2wlF4TL1Z3OgFB/MN8fvYY4cZuM1B
SbgZIVlvM9PnVnLkBsQP9QuFPdAGTa2GaFLpXMaEGpy9pzO60D/cqOapyse49jHD
kq219+YFhGOyZjERZIZZ9z+Ef/d3LMxyKuLfRe+P4bFCGdl7MwE8GHIWxC8RynvJ
+xXPxfaIMO5EeHmk/j4X/5xiORkdHmfzDctdKmQBpcS5rUqkT97AYHj1ESII7lMT
YcT8537uBFBR6wu5EZGyZun5zZPhRxbUXPuk0bCXb6HLrILuJmwT5+sJPCSjtBbJ
NpjMFH9D3YFi5ZtTRPfA
=ar0/
-----END PGP SIGNATURE-----

--1LW0Rr0Uq98qh6Rv--

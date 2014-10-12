Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaJLAqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 20:46:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55762 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbaJLAqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 20:46:00 -0400
Date: Sat, 11 Oct 2014 19:45:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: <dmaengine@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] usb: musb: ux500_dma: use dmaengine_xxx() APIs
Message-ID: <20141012004554.GA21128@saruman>
Reply-To: <balbi@ti.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
 <1413042040-28222-10-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <1413042040-28222-10-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 11, 2014 at 09:10:38PM +0530, Vinod Koul wrote:
> The drivers should use dmaengine_terminate_all() or dmaengine_slave_confi=
g()
> API instead of accessing the device_control which will be deprecated soon
>=20
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

awesome. It looks like it doesn't have a direct dependency with the rest
of the series, so I'll take this through my tree with Greg's ack, unless
you shout ;-)

--=20
balbi

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOc9CAAoJEIaOsuA1yqRE7VQQAI1KG0FoDFd1c/9wwO9P5LUh
mC9UA9czKICHwprzKYDOC/lnH/CBm+mcna6HfKuzi5f/jikBGMF618sClDKLDkj0
uDWuoFlZnnXYJra3ip5TpLoskHoUJCFPQBk1mMeZhEexkqypKgHHowtBZUyqF9HJ
nGb78o3MJA3wHcWHA/Jy0ceypEKl6gYGTGchpFLBf2StItSnPuh2Ew965LEoetjX
1NYvAUrbqPAaHtUnnC2tiHXTUGiRy+eVc3i75Gzfsjn85Xfhfvprnxc/EW8O34il
fdDHSD7wy4VBIUDPE8ojhLz107v1uXinFPP0ak07FimwTO4Fg5Vy9eJWeqBrmTlk
GyPo6z40K5x/gBDlTRXZSXxMH62QQNuFSbxR/b+ZHFbrNIPEos0DGN+uM4wgL3bP
WtxmMZs2DbqSAFudObqVDwAjPKFjEgdzzYHGT9nxXrbqUmLPEKYvOTTIj3UkxwBY
aXC1MJeqYFxXGptlstMBLbwD22Wmeu4X2bmPBf0XKLIHA/PD2pw5NiSHMCLpPFS8
bMN766h6c6kwUFHjrPJmC4RmGftJbmBqKY9ByQ1IhO2u54gqqavQSU2FkRHhB+sL
u5bl3VmNp1/AUM/ytLEnz6d7lNXN4cvQqKjLtbCPbkrOzObenI4/ukS4tBs0Y1yj
SAUJzmPrCfTnd/dhLfYS
=P1Aj
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3BRSsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:48:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45167 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab3BRSsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:48:05 -0500
Date: Mon, 18 Feb 2013 20:47:35 +0200
From: Felipe Balbi <balbi@ti.com>
To: Borislav Petkov <bp@alien8.de>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130218184735.GD10755@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
 <20130218155012.GA30974@kroah.com>
 <20130218155215.GB2663@arwen.pp.htv.fi>
 <20130218171334.GA31329@kroah.com>
 <20130218172700.GH2663@arwen.pp.htv.fi>
 <20130218174527.GB16628@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline
In-Reply-To: <20130218174527.GB16628@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 06:45:27PM +0100, Borislav Petkov wrote:
> On Mon, Feb 18, 2013 at 07:27:00PM +0200, Felipe Balbi wrote:
> > No such device - /sys/devices/system/edac/mc/mc0/sdram_scrub_rate
>=20
> Looks like your edac module doesn't allow scrub rate setting. Which edac
> driver is that? dmesg?

$ lsmod | grep -i edac
i7core_edac            22414  0=20
edac_core              43453  2 i7core_edac

--=20
balbi

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIndHAAoJEIaOsuA1yqREFXwQAJh9HfHQQaUawJmlKM8xexWx
J92s4EeSIepiCw0B1VZU5GOly+gVA7KirlKpDQuoxaegf5WabRqlMlvaoSPjMs8L
fC1u5rgqCKoIRLPa2i6KTv2HpjUe4R8j/OIUSAdIHALe4WxAO0HjG5yJHOuFd0A/
5Osgj5YtaKkNeUang3YnPS870SiLMt+b19fYwS12jxFbCfjLIsqVNn9SdKTYjNz2
38kuxN7kq+Ar7WaXvCgV2gVMMX2IGSXLbI7nS6kQA2X5mLt9ahg3lVawFK62IjN7
qgOq1jLLYUCQaGv2DlNXIHoG5axLABG71JzJ86hGsemWqMcRGSz+KWuZ8DQkjwEN
Le/roZiFJrGoK4XW0d2gPtXB32WSzpcPfZWMZ89NEHwEAICdmlrcsmT45wTaHqyJ
d7KpPJEAeMI8sXevC/YXKKEZ9bQ7tcNoxi6b0w90B3RMDh03/vQu+IWue/gMwbfm
EV++Ep4hsZrdEPNHVmgknrlQGn08gOzNU6aaLLudyb8ZEwFgaOPhFP0BtpvN8VeP
bIAfG5AN6mXWwxfx5wncGGfzvK/3etpgqxNpAOadz2GSGIB3LwOJ4fTND/KbDQIH
CzqUhIg7dyW1iWX3cN4UBc4ZIl2eKP0F23bGMrdRMjDXm2KbSvLttUltkvuxV7Bp
zL1QnqRy8e4qUrJlmbz1
=JFgA
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--

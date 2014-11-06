Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKFOfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:35:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50843 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750975AbaKFOfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:35:03 -0500
Date: Thu, 6 Nov 2014 15:33:49 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v4 00/58] dmaengine: Implement generic slave capabilities
 retrieval
Message-ID: <20141106143349.GL2989@lukather>
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtmVPk+Smchi6n7w"
Content-Disposition: inline
In-Reply-To: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BtmVPk+Smchi6n7w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

On Tue, Oct 28, 2014 at 10:25:15PM +0100, Maxime Ripard wrote:
> Hi,
>=20
> As we discussed a couple of weeks ago, this is the third attempt at
> creating a generic behaviour for slave capabilities retrieval so that
> generic layers using dmaengine can actually rely on that.
>=20
> That has been done mostly through two steps: by moving out the
> sub-commands of the device_control callback, so that the dmaengine
> core can then infer from that wether a sub-command is implemented, and
> then by moving the slave properties, such as the supported buswidth,
> to the structure dma_device itself.
>=20
> Comments are as usual appreciated!

How can we move forward on this?

I didn't have any comments on this version, and gathered quite a lot
of Acked-by already.

Do you want me to rebase on top of your current next branch and send
you a pull request?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BtmVPk+Smchi6n7w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW4bNAAoJEBx+YmzsjxAg820QAJWUObNl8Up+DOUMuaqM0xBv
VZ0vobYnDhGZGhtv+4fQQanA8X/f2Qb9lVUNC7s723KGuGrsAeALN8E9cPpH7Hwl
rKIB2cA31DiBpbTMJhTQc9a13ert1pvi9RwbjchZK+Uxti2SIev+1LDIG/o+jN41
uUPGqRXQt9+S3wkenoXJgQVJz8VRSYWhJLLiu5JvMlTOpBHi9u6xDIkmP15FPzLH
uissfFG0hF37w+6FdjEerhiUmq3r+DCPaOnU2yMIw7d09Y+Ck2dMdWsWBgvaZH9V
wsgS3fQ0HLMRx+9kir6Kfdz1S+KUN9+CSB1IJyXPwI16o7qRuth2F4XLKDVoe0uS
iTy/bXpzwCEzt42M+Mp3ZfDRs2jq7Ul5bqKs9aFvenDG2bzcaUeX/VdAuJxs4unt
QnAKO8pXUKOFCOXpS0CnIEW10qS4SVI70h1Pau+3YhdYymVKz4o34JnkH9wd+Ond
0Hp7jWlgdbUeXbSLNlow+E4PK4U09RXx11EsY9MCgFAR/qxLj00JNXml1/cFyVUF
Y9/1hc3B4lj8TftOQWFhYeB64jZy0vnyK+YcZVrsb4KeJfjsoHakoi2u/2IHKPZA
+Nk3WmkY8LG/9CcqeMwNO/c2US/4NoR/Mj82vV49UtpghiuM5uoaQfbQXG/RtvOL
vhy60nsBv+mND3nf4w+T
=eyxW
-----END PGP SIGNATURE-----

--BtmVPk+Smchi6n7w--

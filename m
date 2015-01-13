Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbbAMQiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:38:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53498 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbbAMQiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:38:23 -0500
Date: Tue, 13 Jan 2015 10:36:54 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 05/11] usb: gadget: at91_udc: Remove non-DT handling code
Message-ID: <20150113163654.GI16533@saruman>
Reply-To: <balbi@ti.com>
References: <1417606330-17753-1-git-send-email-boris.brezillon@free-electrons.com>
 <1417606330-17753-6-git-send-email-boris.brezillon@free-electrons.com>
 <20150112213905.GI2858@saruman>
 <20150112225330.GQ2447@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LwthZj+AV2mq5CX"
Content-Disposition: inline
In-Reply-To: <20150112225330.GQ2447@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4LwthZj+AV2mq5CX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 12, 2015 at 11:53:30PM +0100, Alexandre Belloni wrote:
> Hi Felipe,
>=20
> I've rebased that patch series but it depends on another one (the mfd:
> syscon: part of "memory: add Atmel EBI (External Bus Interface)
> driver") that is not taken yet so applying it now will break the
> build. I still hope to get it merged for 3.20 and I'll resend it as
> soon as possible.

In that case, we either take the entire series through MFD (including
the gadget patches) or we delay the gadget patches until all
dependencies have been sorted out.

--=20
balbi

--4LwthZj+AV2mq5CX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtUmmAAoJEIaOsuA1yqRE040QAJH7NOLe/DsC9soHqjM/ywuR
FmMDrqitvIIcCsAJZL989OwiLNtKV1zlF1xUV0NQxMakmgzefpetKJONdPZ2iwts
mwV224mSVg19kYK5gMf03+ILldMfkArAzw90YBTVYDJdCY+MihuKWT8qzT1lI8pZ
+7w6dPFAncsA7XMA734t/n/56775z6FtVLtY9lL44zrS0J+T9ard11JRyzMO9Ike
mP5fLIz/Ig2+JCecw8MU75UAev54sS36CqZkCp5gEM3eiVGMMOuxGdpbyS8Wm/4K
9YmTbO2N1gdFyKGzdcoB8wf9NivzopGFheZRI2ny1B7Ns9Z2MRXi/EZOmKg/kggc
wpmtiIY4BI0B4gE5j2H3WqhPnrVMOGB+7+k68lCGBkWVd5RpMpF+Ha1JjnFVTJya
Ds7S1ibtgZNDjGtkgkEL7XiURHiOs21WzimRb6p6SZxFfZZmWbr/Hn/gmkiODKF1
gcRP7c8dIKDHhYqju3Nl6PGSyQdEpu74fqvmiBcYsFTF6egzaO/HvJw1w8vzBBwl
CvRpvVOVSETOllKziP3rnqacAwrHajOL32jANmHkBm0sTH7nmh/JoI4hzpAiO/O4
6iyBR00nMP4kBNM43ii+r71yURpyfKG3q3Y9CS/lVIHonvlNA3pVSfFYiAmrTqUp
ckDK0LlNeBssyUIXaOgs
=LXLg
-----END PGP SIGNATURE-----

--4LwthZj+AV2mq5CX--

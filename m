Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaHSVP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:15:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49394 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaHSVPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:15:01 -0400
Date: Tue, 19 Aug 2014 16:13:41 -0500
From: Mark Brown <broonie@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140819211341.GQ24407@sirena.org.uk>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408469363-15901-9-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IjNIXuzrMEaOuFwn"
Content-Disposition: inline
In-Reply-To: <1408469363-15901-9-git-send-email-andriy.shevchenko@linux.intel.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 08/12] spi/pxa2xx: Don't use slave_id of
 dma_slave_config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IjNIXuzrMEaOuFwn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 08:29:19PM +0300, Andy Shevchenko wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
>=20
> That field has been deprecated in favour of getting the necessary
> information from ACPI/DT.

Acked-by: Mark Brown <broonie@linaro.org>

--IjNIXuzrMEaOuFwn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT874CAAoJELSic+t+oim9EXoP/iJnw2cfGs290HTxWMGIFe+0
C6ab9lS8EoJZZQu3TRbdKTTG9dcVC73DHX4Ed1Ezxe3gwDYqsKgfZ+mSjiWhkgDa
hgFS0OAHrMWo/sPR5Xu0gMoKav5rRLdfdvoVobRQ1QFJFEuW/FMls9C/uB8Nk+7k
YPaLzU2ph1GJOPrt2mqb4LIXOCFsWF99piIsI5KwFTGKRCufua+t0ywDc2P/p/7P
Wr0juL9/rfojQMZiusm0l1RidiRMrmHuvrxrXruIowCMvScURlYdQpf55mb0IXjR
7rxJl266pD9Po643YmI/BmKl//6+dGzDgboj13VvMFSfbk/8qmicJmOo5t2P6tEN
Ei0FxXPSt+ynFIf5EmgJESYsYOq0qFlqk0hOVw2ClMrsrJn3fP2wG+sfXeSjCwbh
4Qj8ehP/9AGq2wA6C25Bfb331n1v/E/3ueGci+dkK+VGJUjXd7dMH+Wd4BJa3HKw
z3je8y6oAJRAeun5++VhcAgNW+PUVqN+BHVyGuW86TqTjtGL85haTJ9q1aWnxU15
dx9Q6mZGku3wjAdeim2kPllO75Lxm4ceKAMwgMJWsPthj/8mewabg8TyJOBT3g5i
qcM9M+gsUFPFfFVhGEAiNUoktVhpX1DxSGkyz2s4q0nRMcNJkb3uTfUyPYRyKRz1
ochZ4LD5/RSs6hHhZJho
=BwU+
-----END PGP SIGNATURE-----

--IjNIXuzrMEaOuFwn--

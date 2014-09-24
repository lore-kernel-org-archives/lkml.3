Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaIXIa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:30:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36534 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaIXIaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:30:46 -0400
Date: Wed, 24 Sep 2014 09:30:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Andy Gross <agross@codeaurora.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140924083035.GY4015@sirena.org.uk>
References: <1411360048-3388-1-git-send-email-agross@codeaurora.org>
 <1411464267.18580.46.camel@iivanov-dev>
 <20140923192613.GA5975@qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7uidztUHYC105IRM"
Content-Disposition: inline
In-Reply-To: <20140923192613.GA5975@qualcomm.com>
X-Cookie: See label for sequence.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: qup: Fix incorrect block transfers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7uidztUHYC105IRM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 23, 2014 at 02:26:13PM -0500, Andy Gross wrote:
> On Tue, Sep 23, 2014 at 12:24:27PM +0300, Ivan T. Ivanov wrote:
> > On Sun, 2014-09-21 at 23:27 -0500, Andy Gross wrote:

> > > This patch fixes a number of errors with the QUP block transfer mode.  Errors
> > > manifested themselves as input underruns, output overruns, and timed out
> > > transactions.

> > At what speeds are you seeing those errors?

> We've tried 25MHz and 50MHz.  Both fail in the same way.  Keep in mind this is
> definitely a timing / race issue and it probably also dependent on the latency
> of the attached device.  I cannot reproduce this at all on my IPQ8064 based
> board, but others can.

With SPI everything is entirely clocked from the master - the attached
device can't cause any of those issues unless there's an electrical
problem that *really* upsets the master.

--7uidztUHYC105IRM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUIoEqAAoJECTWi3JdVIfQDH8H/3z5Kjor3KxMUlgCR7OOhlwb
ww6ti3EsagIAQnUcIAazXFldKhjow7Y0cpHKz5cQuEnekxsqfX6TxiyVl+8V9cmq
K/8mt6eI9SuW9+1tOlu7ra9z51VX7V2eSOzzn1laan56idKuEPvQHTc77zP9Hoxa
imMTtOZOIWEYc9S57yvaHbIDIMYYYpaNoNBr0H1G+YXJDcZHsNjNxVcYUHrw0tge
tEA85ExSRW6Sg3l94zH2PscWDH0YEXpdqLoFwbInxiyQ+jCm3oIPSVDcUZtiS1HD
lhEwj93eMVgbKA1j9CjnxKCcsSy3r4RiLxe94MGNRealWXAq3ErBkpOWy86Cx4s=
=dveO
-----END PGP SIGNATURE-----

--7uidztUHYC105IRM--

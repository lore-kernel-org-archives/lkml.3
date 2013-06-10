Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3FJJHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:07:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34196 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3FJJHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:07:06 -0400
Date: Mon, 10 Jun 2013 10:06:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <linux-arm@overkiz.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130610090649.GC31367@sirena.org.uk>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
 <1370622370-19614-1-git-send-email-b.brezillon@overkiz.com>
 <20130607165510.GA31367@sirena.org.uk>
 <51B23B04.20604@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bw96jE97Ld4TP+CP"
Content-Disposition: inline
In-Reply-To: <51B23B04.20604@overkiz.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 28/50] ASoC: atmel-ssc: prepare clk before calling
 enable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bw96jE97Ld4TP+CP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 09:56:52PM +0200, Boris BREZILLON wrote:
> On 07/06/2013 18:55, Mark Brown wrote:
> >On Fri, Jun 07, 2013 at 06:26:09PM +0200, Boris BREZILLON wrote:
> >>Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> >>avoid common clk framework warnings.

> >Applied since I happened to notice this on he list but you should
> >*always* CC maintainers on patches otherwise they're likely to get
> >missed.

> I used get_mainainer script and it returns:

> Arnd Bergmann <arnd@arndb.de> (supporter:CHAR and MISC DRI...)
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:CHAR and
> MISC DRI...)
> linux-kernel@vger.kernel.org (open list)

> Please tell me if misuse this script or if I should use something else.

I suspect you only ran this on some of the patches as that's missing
pretty much all of the subsystem maintainers, but in general you always
have to think about the output of get_maintainer.pl - it isn't terribly
reliable.

--Bw96jE97Ld4TP+CP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtZchAAoJELSic+t+oim9dvIP/3iwvUeVtRLk0BpGPw2zBiPo
w/fXHyi1LXDj3+QW78nDAZKudsIo335Y7HZ4yBWMmfqKnvUzX7K4Hq+MNJNYpO/s
w69VJUERP8QaMFBE3L+BegoueIRFhx8jnar81Qh8K9AQUcBgjj0NqDtqFV/Sf8D7
Rr+KNODWMKk882TN4Ew1YkxqNVo8VoDWYEXRXm59017XJdKeBTHbhKvg/WIs7oRB
2eV67JuJ0FlbmjaS00AxbFv8bdfVbphPyHHFQSX5T3EeswdwaBlZoZUMPAXB6SIB
+P66S+ntGwl8etkPtRT8elIW33T879U6TPG/wpI5cx6rzKsnMgZ99Q2yiHL+EmEp
WBKE7WWgAqz2IkqVxjvP6dCUyYL5nrvJBL87XX2HXGx/59xXYoqpCJlIZb1m0Vdd
qMYORU7dJbgJ3XGZcBScGrHLedGpb1QY72pOu5aReL5mp0QhZc3zvMJ8abCaxqIJ
AMNpP2WFeQ4DYxx/gE7xcQoe0fhhkncCN7WNnXTMKimAbVvUaCWpmZDURL54U0vW
6xbQdU7IQm3Mu3TYE99I4joyq2UGIgtQIqf+eecFN7DG72zURNPLnQWae1DFXyTc
OFlTHi4syO4MV6CijO7Ewqmp5WKcnLT495Rs3xx6McA89Svb7pHTkRog3Xw9W6K5
Rq1XT8OGb0aPKlyS73Nf
=T/Pd
-----END PGP SIGNATURE-----

--Bw96jE97Ld4TP+CP--

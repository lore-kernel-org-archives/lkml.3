Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaBMTDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:03:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42895 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaBMTDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:03:34 -0500
Date: Thu, 13 Feb 2014 19:03:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140213190322.GA28112@sirena.org.uk>
References: <9348920.79Ktlcbcai@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z6tBdMCc7//q+vBX"
Content-Disposition: inline
In-Reply-To: <9348920.79Ktlcbcai@phil>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio-regulator: fix forgotten gpios-states
 reading
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z6tBdMCc7//q+vBX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2014 at 12:48:52AM +0100, Heiko St=FCbner wrote:
> From: Heiko Stuebner <heiko.stuebner@bqreaders.com>
>=20
> Commit 934624d6e9f0 ("regulator: gpio-regulator: do not open-code counting
> and access of dt array elements") forgot to convert the recently added
> gpios-states property using the same pattern.

Morimoto-san sent a fix which did apply so I took that.

--Z6tBdMCc7//q+vBX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/Rb3AAoJELSic+t+oim92O8P/37BBNmqc34v/xZESVga3cL2
OtZlurWPL1Ovzhcv4n7IA6qy4i5ZhFXdtPTfB7Ou0+Dj8LWsChmMYX7F+WkyJiDe
3vkZlC3jLqkHEgovUxxk7/ekPAIEXxS9KYXYusb6YHXXdz7mSS93R/y5+NvYxlBS
qowpiq8bjrKemcYa9nUQ97NQC8X6rcyLa6FTqBmp942eV/zdU7EuvH6KEDhPTFQ+
wPlhR3glYBdUzT/uhsnpdOQP6D3Vf2Z2eIjW9LGBBMiEhEbpNPXYnU5SnW4YjBE9
UrrTtHdMuxYW0RXmXTSVXsNWYEIZXxx0ItGj480hj4wUHc1n2gGpAaHrNIZ0ljXX
X89mAPYvL1taNzmkZiZ6FR0pzqajhqMR4r/3n9v2CJDr4NkVWQ7/IvXrG2gvDIqK
aZs9xWqUccRlr73FXERng3rYksNu13Wvfdq9crMGtU6EKHzYPVAuSfNafipzvk4v
KZerZiw1f0RAmDeyZV2s2dXMvaMo+oEnQ8JZ1+4jSKlmb/8O20+3itGbPvNUty8v
PbDpckZfOOBhUEVYw63kW0n9myXgE5wy2R0dHz9drCjGTMWgYZ11Q/LUZjfrYes+
f+vyXDp/dLBaddt9/zk+6xia0LluWY/BAdqu09EmYSiIKdlwXi8TXiN9QcHVN4Vr
rqiUQDJ6K3u9BPleGES8
=fbhg
-----END PGP SIGNATURE-----

--Z6tBdMCc7//q+vBX--

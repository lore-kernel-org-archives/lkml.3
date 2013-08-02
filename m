Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3HBQao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:30:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37119 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3HBQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:30:43 -0400
Date: Fri, 2 Aug 2013 17:30:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130802163040.GR9858@sirena.org.uk>
References: <1375441184-1977-1-git-send-email-zonque@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gpy7x6suan4eN/"
Content-Disposition: inline
In-Reply-To: <1375441184-1977-1-git-send-email-zonque@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] regulators: max8660: add DT bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gpy7x6suan4eN/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 02, 2013 at 12:59:44PM +0200, Daniel Mack wrote:
> This patch adds devicetree bindings for max8660, along with some
> documentation.

Applied, thanks.  DT bindings ought to be CCed to the devictree list but
this is very standard so no pressing need here.

--b5gpy7x6suan4eN/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIbBAEBAgAGBQJR+96tAAoJELSic+t+oim9QBMP+M7S6rUHde1qIx2i2kHXGMai
EqmesQTxjBe3U1q84tlHh2ImypxFSZV92i9e6wQye8d6CxP0Lssi1yeDYn75OdNV
2v5UK2C05zQ+I4+9xhBrOUKyvwmztkwuRfns+6nbYU8sbsvB+PYkmVIMYixYjL81
xHY19QQGjDgwCIk9J+ymd80C9pdC477REVoXm/e4r4oiGUwFa7VRoQecu9JB5r7y
Mfjxj+6BzwErO9btdvnavH2619wWKptEhP8nwHGeEG8j9E55db5qm5vbUuidwmZI
sWEtw8mS+gcmlE7kHmDBB/+JNMxMq8SQsIAOPfoJcBVFvaSusTc0UXGOrmRABzwr
HZnkjQGmqkvgQbxVRFJY/3jfjPrureXA8X/WLmm0HkAJ/ZcWp6VCTQVnvsYi5KUx
pfHfzZlRziBAe4KLXbdLxj8aavlpFLpM2vP3rb5y5Xl5cLIzY1M+b4JxrfdPkK/J
MukRY5AodEmhOdQivPWgxL0amfti75HWnjxF0Oe7G/Et75ggkVzy/961pFBMH77C
B9AmqCuJRnU2VJ+gS6JP5fxugqLQFDnLdf5ihgwMLyq/qvrleYsCYuEGJG5k+bxu
rMetcEC0ZeH8GIr6CF4OFQRZMIV0lq2V1JNszXImMr8OrtecsEipMmsL4JgVr79D
H0vEMp1wc6GCV9dXPnc=
=qis7
-----END PGP SIGNATURE-----

--b5gpy7x6suan4eN/--

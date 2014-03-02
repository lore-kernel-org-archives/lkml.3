Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaCBXqE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:46:04 -0500
Received: from ozlabs.org ([203.10.76.45]:39489 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbaCBXp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:45:58 -0500
Date: Mon, 3 Mar 2014 10:41:40 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: xypron.glpk@gmx.de
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        devicetree-compiler@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Consistently use xrealloc instead of realloc
Message-ID: <20140302234140.GD12916@voom.fritz.box>
References: <1393792741-29043-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Content-Disposition: inline
In-Reply-To: <1393792741-29043-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 02, 2014 at 09:39:01PM +0100, xypron.glpk@gmx.de wrote:
> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
>=20
> fdtput.c:
> Replace the remaining call to realloc by xrealloc.
> Some redundant lines in encode_value can be saved.
>=20
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Applied, thanks.

Note that in general dtc patches should be CCed to myself and Jon
Loeliger <jdl@jdl.com>, the dtc maintainers.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTE8G0AAoJEGw4ysog2bOSaYMQAIto65iqA1mZWk9uH9ruJtQm
VAkfqi9IQL6WYYcXJitsbBY34RyxB1HJvq0LWqYKZj7+8DZXs8Z85LMvI9XgmuaS
vM4HE5Uw+nALfCaBvbrlQuNvquTSR6qVlBXSAL39OqjWgEp1/MEnMD3tngFG0f8I
QIJNwUNjqoZqiS4FlMjE0ntwyf+P3oeWsRK5AqSiAY/uEFj80H/9U99/DH52UBP0
W3zSMlUxLDp8n3b2aYLEYIdjOgjGoQz2hDMw2GKKK7meTVv8ztSf0LYhyJGpv8a+
9IeGRLcn3hHrt7hK7m0LKmv932uUR07PBm0ZgJ+UQXxv2+Ba3XPjLKESx64Z3+/u
rVYNKlnqDKaaQcSpmGFNPmUqD0+PJRRBs0fdziZ0xHe7kA8D8YxnKvB18F0tTLcd
80l9gjqOnnVL60bQr6ctZDF2+WxChQF9duyzq7U7rIBVbeu7dm3cAguzYA8UfxSB
r+2HFLh8UvktV9vH+hsdcd+8qCpG1jVwGoYKOwHXg1fn2JN/73qcChB9/yHpXJNE
gyi19ar8eRILAxGx0odclpY+2hZiSogKHXNtwGJ6ldlK/fEr6IV8Asx0v8SFzUCr
XPwfrLObVDl8P5UWeXobFbeYju2uE5L/Dp/M0DGScAI+aTqTldjbpDJcK1KVRlqS
cE4JanVNqIFOi8TNCdWW
=1UTA
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--

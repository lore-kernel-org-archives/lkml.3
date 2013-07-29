Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3G2BoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 21:44:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36762 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab3G2BoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 21:44:04 -0400
Message-ID: <1375062227.2546.57.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH stable 2.6.33+ ] tracing: Use current_uid() for critical
 time tracing
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 29 Jul 2013 02:43:47 +0100
In-Reply-To: <1372875744.22688.114.camel@gandalf.local.home>
References: <1372875744.22688.114.camel@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-a73M2a3Zd/++7sAXGtsY"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a73M2a3Zd/++7sAXGtsY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-07-03 at 14:22 -0400, Steven Rostedt wrote:
> upstream commit f17a5194859a82afe4164e938b92035b86c55794
>=20
> The irqsoff tracer records the max time that interrupts are disabled.
> There are hooks in the assembly code that calls back into the tracer when
> interrupts are disabled or enabled.
[...]

Queued up for 3.2, thanks.  (Not sure why I missed this in the last
round.)

Ben.

--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

--=-a73M2a3Zd/++7sAXGtsY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfXI0+e/yOyVhhEJAQqe/RAAoEQ+vGJzbIVfHlF0uIPy3uOchN02j9dn
QS15yhPQVDiYZToHvXKaU9Fu593TyXwJVMQrXpQ7a+9FRbiZvYVKhXuA2cn3xAKE
w7qoZYDi+PYR8qOoomM/9ldxi5g0mSka2mBN2dF6DMLeB0f52qfdBWQLjLkq97jf
j+ZvG840cFBV/BUuUu5togfB+c3kx4jgBv5BRGUb1enpwtWSPr91yW8Qq+43iMkO
4pYUSq0GKJh2XXHBsMavC3TNbmyWksrNvE68sC1M5bHULLtOQbTc9tmeumzCijY1
pt4z/4gcTQQx8mcEKIArIrhoCQ2nPdemThXAhAnPnERvnnbENMnUdqENOt4kLCeE
8rlbPc9oT/QC19kS1mvOih6rFL133aTz+Wyx+J9agzAGMx/+lLcOdkxAIa47SKfo
AKeRenLTIqbuiCF2Xb7E0UsZATYk6aPL0yuhq9d8DA7avH9BISJFfBeCwoV/spDA
IwL5TGgcUUE0+zTU1GLWsrjCfhRqQ9ZaEshkr18VxQoXzbhuVD6edLyl+dxYqs8Y
l773xsMBQwsvA+Ti7a9+Xw9mpxfFCNVsvrZxxaotlw4wo6q9xGv7LgGOJ6lIj2QA
jVF7t/N8TK5Wb4SumN3SpwxAW0GYu5+/urCcdtA3UToHMeaY/jQYIQxfAQS9Fm5V
vQ3LJvhFPkM=
=FFtJ
-----END PGP SIGNATURE-----

--=-a73M2a3Zd/++7sAXGtsY--

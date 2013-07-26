Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab3GZKzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:55:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44081 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3GZKzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:55:47 -0400
Date: Fri, 26 Jul 2013 11:55:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20130726105519.GZ9858@sirena.org.uk>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rF/K8g1/cqPmwA9E"
Content-Disposition: inline
In-Reply-To: <CAL_JsqJQWOLC9f1igEpsgJB2X8mFDpqLDaFFRjGGVHctjWZLgQ@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rF/K8g1/cqPmwA9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 02:11:31PM -0500, Rob Herring wrote:

> I would argue that little has gone in (if reviewed) with the
> expectation that the binding will change. Many of the common bindings
> have had many rounds of review and they have not changed. My position
> any time I see an incompatible change has been that it require anyone
> affected to be okay with the change. This has pretty much been limited
> to specific platforms from what I've seen.

The big exception I've seen has been the OMAP hwmod stuff.  Plus of
course the case where things get moved into the DT bindings from the
board file as things are built up, but this should be becoming a non
issue as people move onto DT only boards (though I am worried about
people on systems where the SoC is described in DT).

--rF/K8g1/cqPmwA9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8lWUAAoJELSic+t+oim9UH0P/R7oRtO4An4tjF6iqo7gHp0Z
Bx5V5GeP6PRC2ZLz266cgjB3/1hSZZFgGjPvBsox4tSQGdPTlEmAbdgqbKYFeNch
48DTTZhHfSu4UL0x4jx4Fqiv7RUAN2bOPDkdmGnc6XBZZ5u3QtAzhfVbEZHTl0g/
B4xjRtK63hC5yRzQzsisLNt+KOHeDzyBqxQQBqK3MXk+yg+L4onKgLkAv014Ej2y
zmAEwvxG3fMYPHSdbrAAnOhdqXxZVy9gff4Abt3ApEMsS1hyyufDJnJvnMwlmz8m
XJpxI9Jq9LbahatrUS2668lfpvkjtkOXDJwisJPgwalNMr4yC7T8suDQ9qys22ao
t/GfsnxwM5veptXbVDpKvja8K1SWy+4P8xAWNH1h/gdYTpIqc2Kx3TGvr8P50oXA
b/kGPU4cQsNCE5Bgh8q+y1Ndi+gnPxlqh7RM9lGYjRvuOKgvXhMQWdQmY0CqRUvd
tducQkbISXmW6HnhkHFkMSz5QNxhyaVCyqL/jwkdRcy8c+GkdwUxleyJ1CQjJ7Aa
+iYMus+6gEmT0dDFLDFefqZe3NZRXRoQuqKJnc6www2aoNXulkWIlmh7DUbLKRul
8LqnaB6NB3+5Naq/mMeXHJckxRdv5IRtpgI18N+iqMyO7606mB2SagUalP8UCgOH
IhjO9LrpLtEg5FsKFWTy
=VU8c
-----END PGP SIGNATURE-----

--rF/K8g1/cqPmwA9E--

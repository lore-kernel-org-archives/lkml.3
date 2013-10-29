Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3J2L42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:56:28 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65499 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754938Ab3J2L40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:56:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pm tree
Date: Tue, 29 Oct 2013 13:08:23 +0100
Message-ID: <1919820.jZeQGKJQBQ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131029190021.bb2dddcbd46e1ddfdfd5e441@canb.auug.org.au>
References: <20131029190021.bb2dddcbd46e1ddfdfd5e441@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5083526.LKA7sIihtx"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart5083526.LKA7sIihtx
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Tuesday, October 29, 2013 07:00:21 PM Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap2/opp.c between commit e4db1c7439b3 ("PM / OPP: rename
> header to linux/pm_opp.h") from the pm tree and commit 92d51856d740
> ("ARM: OMAP3+: do not register non-dt OPP tables for device tree boot")
> from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The fix looks good to me, thanks for fixing this up.

Rafael

--nextPart5083526.LKA7sIihtx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJSb6VAAAoJEILEb/54YlRxg40QAKJtob8OJfZ+0xIWF3b5CMvm
vTwkwYAyCzR4gtYJKMbNe7El1tZMRMhz/iI0kXJtyofgGc6r9Hcguf2pDla6z5xk
4f66PgvXI8Hq073uo/O2kyFUEPCzrSR0Sa6Uz6/5b+VMllHXdoTtQ8GLjafXLqLa
NXRuS0J+oyFNU00FZ4qadCMfoXNEXzuBMSXd5yojSkoTlbvVUlvDo42G/IEdHiEa
oCeah+lrYNNGXNthqL0gz+NqgSykwTiOhB01N1mL6ADbrTXFmmpqk7hMa+PBR6TM
kOMuI2Mqa/CnmW/sI23lVkGGDAnDALXQtXSpRPizFQlziNxbUnpew5/gofzF35f4
74AhgO0P2e3/YrjC6FRn3z/6O4QlrF20+mhtF+FSqE7a/O3srrKY5p+1SEENujhh
gz6bIlDIY5S+N8qo3UIxM6huEkXUes0s45M4VfmPT4Cw5ZeMZpEeXZ/7QteOEnP1
IKmjcGwQJ6G3YHaXqQWZuKnSVSKeQavUK2HFh5QQgyHp7S+gbn7PGlqdf45d+7gq
VKfa5SbQ3C1+FD72/4r4I3T3BM7qjMrbNok1U4kPINIwK+SoF8XwVrf87/G0oVq8
M0O0TOfrZmOlE368bU1eBaRrEMvFqoYsxnu2VZ6e36VkIm75uy7PN/9go23HJwKq
q9+jTrdvwL7PwW6GiWUd
=5fhK
-----END PGP SIGNATURE-----

--nextPart5083526.LKA7sIihtx--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab3KSFtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:49:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3KSFs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:48:57 -0500
Date: Tue, 19 Nov 2013 16:48:39 +1100
From: NeilBrown <neilb@suse.de>
To: Sebastian Reichel <sre@debian.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Grant Likely <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH v2] itg3200: add dt support.
Message-ID: <20131119164839.7cd3f4f1@notabene.brown>
In-Reply-To: <20131119014938.GA20782@earth.universe>
References: <20131119113013.39dae3cd@notabene.brown>
	<20131119014938.GA20782@earth.universe>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//XwP1PsStxcHcGrjfeISlYD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//XwP1PsStxcHcGrjfeISlYD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Nov 2013 02:49:38 +0100 Sebastian Reichel <sre@debian.org> wrote:

> Hi,
>=20
> On Tue, Nov 19, 2013 at 11:30:13AM +1100, NeilBrown wrote:
> > No new configuration, just a 'compatible' string and
> > documentation.
>=20
> itg3200 looks like a candidate for the list of trivial i2c
> devices [0] to me.
>=20
> [0] Documentation/devicetree/bindings/i2c/trivial-devices.txt
>=20
> -- Sebastian

Hmmm... a file that isn't referenced anywhere else in the kernel
documentation so is unlikely to be found except by people who know it is
there....

I can see that having lots of files for trivial devices is rather clumsy, b=
ut
there must be a better way.
I don't suppose we could just put the documentation in the device-driver fi=
le
in some format similar to kernel-doc and just extract it if it is wanted
separately?  I think people read code a lot more than they read
documentation. I know I do.

But I can re-send with an update to trivial-devices.txt is that is what is
wanted.

Thanks,
NeilBrown

--Sig_//XwP1PsStxcHcGrjfeISlYD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUor7tznsnt1WYoG5AQJVxhAAtjwgPu/xThBn/uG19TfyH9EPA3r0LUSr
1YXQTcK5iI7soYxSXAbYLZDyGVk/JEd7a6+78/zADRG1YH5WiZHSLo9ns9sJ6lNF
/VGz6SxrSVctrps4sowsIeZCHLuW8hPGQpTRCrQMO/pclZnoERwlYOIMXNO8bAD2
UrGACHZcUiMZDWztwAmgsapAmKRFjW4+RS+XSthiLbDVgErSjJoI6mtJcwz1pj3E
flKEaQhGtD8t8awtjZHYbAQbBlBgwLn9LyfsRcBmoiX7AQ6Rn1DuOIOzojye+PGO
PYng8ks08Dq5R6h3TuM0vEOZphf5uK26lLbjkSnygMFWYxCuVzvnFqW06Tjq41ch
A8GbQZPA6iGo9oaFNCX/Z5AOTEo7xXPydvzfMAoM3YBKHAtqujpFOBq7NA13rPVF
gSwNRPgudabj7Ffbr+pUilLonYjwI+KGfvsIlCwUlr15oqMVexwdkxAWRAjLnI5/
hCeiV/dEBXzSweaERYehEkFwUQUY21EA4TZwPmSmhkGL7pqfT3UNulkNEzNJIEH+
VO8L4qbrT0j+nPYWiFAZ68MdcTalcRe2N3Sj2xeeDrQqdmSlXj+p6D4miXAp0zTq
jbbJfqpDGRhh1I9q4dNWaqhIEZFq16ZiNAAVvtdL5cWNr+G7CoEPUxlTlB4XToCg
1+Yg30BvvOM=
=Yxmd
-----END PGP SIGNATURE-----

--Sig_//XwP1PsStxcHcGrjfeISlYD--

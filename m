Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaKITgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 14:36:25 -0500
Received: from mout.web.de ([212.227.15.4]:65177 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaKITgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 14:36:24 -0500
Message-ID: <545FC215.7010802@web.de>
Date: Sun, 09 Nov 2014 20:35:49 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        maxime.ripard@free-electrons.com
Subject: AMR: sun7i: CPU hotplug support?
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iqbXqoQDMgonWuNh6lTK641AnRjAwWenv"
X-Provags-ID: V03:K0:4jTRNJzuLDtedjv+FvgTuit8RUwxwsGZ56UF0/DCL+30ke8phbI
 aNGjyhV8AByQ1hWFfp383YxHA4pNeXuiesL0sHOKBEMv7eoUrkTgx0TxxIyeeVGsKJxBzTA
 0wIfjKCKXqowI2Bby4jU+IPxuWIecWf2YFtGi+tSVZPtQz0NRd81zeGaoBJEwCpCBI2fYhZ
 Uyzqw6E4UyV2WWBmCfrsw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iqbXqoQDMgonWuNh6lTK641AnRjAwWenv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

did anyone already happen to look into enabling CPU hotplug for the
Allwinner A20 in upstream? I'm currently running the sunxi-next branch
on Banana Pi, and echo 0 > .../cpu1/online just hangs the system. The
old 3.4 LeMaker kernel works fine in this regard. I can try to look into
details and port things over, just want to avoid duplicate efforts.

Thanks,
Jan


--iqbXqoQDMgonWuNh6lTK641AnRjAwWenv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlRfwhUACgkQitSsb3rl5xQgFACffwygHbjqfNkgl7Auk50EuaWQ
ANUAoIxe7WIB1PNpq5z0imCMCl7yCRaX
=WrEk
-----END PGP SIGNATURE-----

--iqbXqoQDMgonWuNh6lTK641AnRjAwWenv--

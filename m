Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968Ab3BBFFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 00:05:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44405 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3BBFFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 00:05:02 -0500
Date: Sat, 2 Feb 2013 16:04:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        linuxppc-dev@ozlabs.org
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20130202160441.456a233e3c992d91ff3336ca@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_16_04_41_+1100_k54kw2P82i1Ng3cq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_16_04_41_+1100_k54kw2P82i1Ng3cq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/perf/power7-pmu.c:397:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:397:2: error: (near initialization for 'powe=
r7_events_attr[0]') [-Werror]
arch/powerpc/perf/power7-pmu.c:398:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:398:2: error: (near initialization for 'powe=
r7_events_attr[1]') [-Werror]
arch/powerpc/perf/power7-pmu.c:399:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:399:2: error: (near initialization for 'powe=
r7_events_attr[2]') [-Werror]
arch/powerpc/perf/power7-pmu.c:400:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:400:2: error: (near initialization for 'powe=
r7_events_attr[3]') [-Werror]
arch/powerpc/perf/power7-pmu.c:401:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:401:2: error: (near initialization for 'powe=
r7_events_attr[4]') [-Werror]
arch/powerpc/perf/power7-pmu.c:402:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:402:2: error: (near initialization for 'powe=
r7_events_attr[5]') [-Werror]
arch/powerpc/perf/power7-pmu.c:403:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:403:2: error: (near initialization for 'powe=
r7_events_attr[6]') [-Werror]
arch/powerpc/perf/power7-pmu.c:404:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:404:2: error: (near initialization for 'powe=
r7_events_attr[7]') [-Werror]
arch/powerpc/perf/power7-pmu.c:406:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:406:2: error: (near initialization for 'powe=
r7_events_attr[8]') [-Werror]
arch/powerpc/perf/power7-pmu.c:407:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:407:2: error: (near initialization for 'powe=
r7_events_attr[9]') [-Werror]
arch/powerpc/perf/power7-pmu.c:408:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:408:2: error: (near initialization for 'powe=
r7_events_attr[10]') [-Werror]
arch/powerpc/perf/power7-pmu.c:409:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:409:2: error: (near initialization for 'powe=
r7_events_attr[11]') [-Werror]
arch/powerpc/perf/power7-pmu.c:410:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:410:2: error: (near initialization for 'powe=
r7_events_attr[12]') [-Werror]
arch/powerpc/perf/power7-pmu.c:411:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:411:2: error: (near initialization for 'powe=
r7_events_attr[13]') [-Werror]
arch/powerpc/perf/power7-pmu.c:412:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:412:2: error: (near initialization for 'powe=
r7_events_attr[14]') [-Werror]
arch/powerpc/perf/power7-pmu.c:413:2: error: initialization from incompatib=
le pointer type [-Werror]
arch/powerpc/perf/power7-pmu.c:413:2: error: (near initialization for 'powe=
r7_events_attr[15]') [-Werror]

Caused by commit 1c53a270724d ("perf/POWER7: Make generic event
translations available in sysfs").

I have used the tip tree from 20130128 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Feb_2013_16_04_41_+1100_k54kw2P82i1Ng3cq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDJ5pAAoJEECxmPOUX5FEMssP/i3pnYGfgpkd47FVvKRlGsep
ZD/UpkwI4iGkUoOVMUa+CyH7+XDVz0BNP2NlXmAdLjmk/ozsaBvlGKUuH+e/u+NS
ZQgsjsgct/7RvQMSTEP0T6hTI9crePRc/uyWiIcrPTabmyUN0e7tddqwFrAaUzrk
WsA+f1vlirOWZY/IufFUSO/GNO3OCSYYHfM3JwW9QjWnoQIgyg+LkqTWIBSGDf4+
VvjKX2BKdwidWrUCiFaI86hwtlAcm1BlEb+Z92u2etImN5nC2lXPIU+77vQiZEKe
bJUAP4FIJoz8DUzCtRCF8g4kB0Ar1raszcWtr+JuS/7CF6FuxfiA+D+37VBZGQwo
N4x3xRuAbB5qaSMqhahZbCT/LPPEbTLT+Xz/FXC6M72D0XU+K36xLQzbnHTzAyBS
cQija6Omss+keDM1rJHCCXJ2TfsVBBks2gpHbkebsObiIV4iov9Cx1vFJomNU2Z1
3LXxDpHbd8CE4rKXHPkhOYx+jlotjsMANvX0AIZHe7epSah9wfG74Emoehv0vfZ/
wbAO6CRKwOeMHsbgQ+8fYs6KScJhvxWNZ33IsbH0j+EqOmcXL393Wa7WD83rgJ23
BGjcgSLSQ9sovW0OY9YekqvLMLPqOwgh+5s2vtGQ4LWoGYAKlmWMbL3FUpX/y0Ek
lMYzj3iciOkFoFrvJbAn
=jwwA
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_16_04_41_+1100_k54kw2P82i1Ng3cq--

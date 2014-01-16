Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaAPEDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:03:53 -0500
Received: from ozlabs.org ([203.10.76.45]:34913 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbaAPEDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:03:50 -0500
Date: Thu, 16 Jan 2014 15:03:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build warning after merge of the clockevents tree
Message-Id: <20140116150341.506a8d292d722c5878340b57@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Jan_2014_15_03_41_+1100_+VLJy=VMhXFYHdj3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jan_2014_15_03_41_+1100_+VLJy=VMhXFYHdj3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

After merging the clockevents tree, the file
drivers/clocksource/clksrc-of.c.rej appears ... it was commited as part
of commit 55af97749f2b ("Merge branch 'clockevents/3.14' of
git://git.linaro.org/people/daniel.lezcano/linux into timers/core") which
I suspect was added to the clockevents tree when you based (or merged)
the tip tree.  That commit no longer appears in the tip tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Jan_2014_15_03_41_+1100_+VLJy=VMhXFYHdj3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS11ohAAoJEMDTa8Ir7ZwVbgsP/iNu/pm4gVeSYW9t6ZRhJa4n
FwJ+ViHbeerCKbPOpW+w4XWQ78oxC0yNrHU6pD+EBrFkIINKZt2TlIis0rJCDHXz
kxAp/Xd8woso93JF7MzEAjJK4PqDayBafN5YA0WUAcqwliHqCTtSbST2DeVw0/2q
i1RqONrrMhVbWzuKw2HnuOPM2w9Lgzj04EoedsZ8Py4Ej4YxPHepcT2qNMUJyvyl
lnfCfqmZTxXPZOeRYIMceSGucicK3BrF1A8+vatL4TCPVwsaTAFU4FhN1AnkcRSm
dZFLEuOubC9n4Ip5gZE1BH5gAjA0N57zLziJ5o9DB2DEhf69kBHOrEHVwzEacm2k
FXvl6bbu9nNSlMjvJ4Fj7XBdzjbTT+WnBFcGmQ48bwEU7Pi7j7UGzz5GUaXGvLRr
aet0KSvEclRM7KaY0OYvwiqf5IO9TYR1d29RyeD2o96dE7IXDwDsVZWOEd3Sn1K4
SjaO1g6rRXOxFPZtPI4XSeR8J8ohQuGmENQf9u5nqa79fWDerOg7QhwdcSHJal4G
Pc06UUWDjfW1KV7s9xGRI2ffUAz6CK/W7Ip58GpIk1liwD76Sc0Umtq4Sflz2RQH
iMsnGEdcjrgdmE4uDqBtTUDUqz6R5gaXLB9JQbq1s+mKpAGPgIxEhgws2bQ85gxj
oXhpoKIM3MgflSbvYHtb
=WLXS
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jan_2014_15_03_41_+1100_+VLJy=VMhXFYHdj3--

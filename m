Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3CDAhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 19:37:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58552 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3CDAhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 19:37:03 -0500
Date: Mon, 4 Mar 2013 11:36:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>,
        Heinz Mauelshagen <mauelshagen@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: linux-next: manual merge of the device-mapper tree with Linus' tree
Message-Id: <20130304113647.c9d5cf947873ddd476a18506@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_11_36_47_+1100_b7/ThKFnZpg=B3u5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_11_36_47_+1100_b7/ThKFnZpg=B3u5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

Today's linux-next merge of the device-mapper tree got a conflict in
drivers/md/dm-cache-target.c between commit c6b4fcbad044 ("m: add cache
target") from Linus' tree and commit 2db8e6e2cd1c ("Add a target that
allows a fast device such as an SSD to be used as a") from the
device-mapper tree.

These are basically the same patch.  I used the version from Linus' tree
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Mar_2013_11_36_47_+1100_b7/ThKFnZpg=B3u5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRM+yfAAoJEECxmPOUX5FEZ3QQAKW++h5l9NrzwXnKV9PB4MBG
8+NY9Jg5eaUQTM3EshdTkPlz8uaA+cSfXGJhx8E/TJWbQLCoAg9MCOtlqccHBRYE
fXAZvCgc8TFlk81CBUKPsoX4sFQ+egZezXtPuyIV5ajvfWFM8iCgcK6k8bpboX75
YYcdnX1JAPJI4J9qd2FhdjTMCsT3fcpVKNuAQouC8GV+VhjWRU/SvX+G+FZIFr6d
C8bm3CCjmaFnKSpm0M8LMz+79YTsdmg5HOnU0zWmlLAIndkS95LQahVcr+5Zaw0U
xooG1dGO0nv/v6R6lV74WAbzXngeAlkLFnz2dg2EX4KEwmWufPeJ04ktt5yWoDBD
KZGEsQpBKrtA7L2v42ynv8sn8OSavIXuj7rHfiOtFFOirvYa5kROIhZyC1zRG3ZT
bbVDJMGW8vt+U0b3lQqlpC3WLNOBJIHNWqazqyOIcbwkDs/5ThmbD8H+x/psrW2F
1F9MPgCnQFG90sKWDNMb7qZtnOTv1nSY0EvJbC2q6kvooBp/e14SLF860PQ+SHFp
dVgwRK2+ZDOo9gya6ORd6vyFU5aw2nGYe5WPFPwm3xpVkagTE2ybNwxcSChBqS3i
+mxgXEYIUBzNh/ZXQi9HgIgH9+4ecDuvAeAmxeFoKHOmHDdtnnnQHfzFzb5iRbIN
yteM8cgXCrJFFSoA6rWJ
=M4+W
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_11_36_47_+1100_b7/ThKFnZpg=B3u5--

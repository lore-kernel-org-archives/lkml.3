Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab3BXX5C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 18:57:02 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56451 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351Ab3BXX5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 18:57:00 -0500
Date: Mon, 25 Feb 2013 10:56:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: linux-next: build failure after merge of the kbuild tree
Message-Id: <20130225105650.6b89477b11c895ba99a666fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Feb_2013_10_56_50_+1100_iOe5MZuE3c4Kkt18"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Feb_2013_10_56_50_+1100_iOe5MZuE3c4Kkt18
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

After merging the kbuild tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

scripts/link-vmlinux.sh: line 135: .: .config: file not found

Presumably caused by commit 03b25b47e0f4 ("scripts/link-vmlinux.sh:
source variables from KCONFIG_CONFIG").

I have used the kbuild tree from next-20130222 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__25_Feb_2013_10_56_50_+1100_iOe5MZuE3c4Kkt18
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRKqjCAAoJEECxmPOUX5FECOYP/R6ehFMiuKYRaZGJeEkgJeSR
ROyvzzOYlLbIJfkxN4X5BJddVyO1dU2a2kmrtoDQToue+rMvaGHFe+XJYZecxkSv
UftrbiXepcQ+sY3DWf/eH+kHVlyjm9cRQF5Fq1lhfmHO1eAvMw8/GuVsJWH+YQdZ
q4WIHzbNlS/zd/nLKIpsEqS2RndTWx+iGQ1NziQhdXEpI++cSArSoL47Q+2cd0xX
Vu6MXyBTMXEmWlMpGybwbIyc0MquwHV+8npivqZoDfeNSBSfHg7RRQ+xdgCbg3YM
3Kvft4w/7nzd8dInXk/tJ3SeWJhVc3j9MabkLRg38Qr7VsjRRAb+XqXi7CLK2Hq5
0LMKUr38X+PVAJNn6G2D/yf+iQih6AYg8kwtIwN78V/suDI3LkpzbCgqqrSa6g8L
94THnRKQy4I7AOFq1E0Hc4coplca/7uZjxVcvO22bnXRai0jGab6alBenTvDMNHp
PJjkQAsyFo1k3WdM6UEJ73VETrnWVw1Rnag069I2IpsycGwIALKEzqQGCi3RdpHv
LjqxmntKkptHTcwaBcmTa+OyqqxIMgrxNYAR6fOSnVkjJfFQDlznML3hEbtVq7+s
ENIBoGD4HxN6oGl4jbm0XRQhYWULMhCl9zjXzFNdKd6Nrx69E+GpOwfGe/o2ex+3
dXpuT7yyDultTHSN/OFC
=SvVf
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Feb_2013_10_56_50_+1100_iOe5MZuE3c4Kkt18--

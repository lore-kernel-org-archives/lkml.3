Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3F1AhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:37:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33137 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3F1AhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:37:04 -0400
Date: Fri, 28 Jun 2013 10:36:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@freescale.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Robin Holt <holt@sgi.com>,
        Russell King <linux@arm.linux.org.uk>, <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH linux-next] ARM: keystone: fix compilation warning
Message-Id: <20130628103655.317a09935f845819a587c6f8@canb.auug.org.au>
In-Reply-To: <20130628102308.d338543da54faccf9bdfe2a5@canb.auug.org.au>
References: <1372337367-6708-1-git-send-email-vincent.stehle@freescale.com>
	<20130628102308.d338543da54faccf9bdfe2a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Jun_2013_10_36_55_+1000_IMjGVTQWWB=XkGv5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Jun_2013_10_36_55_+1000_IMjGVTQWWB=XkGv5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 28 Jun 2013 10:23:08 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> This is only needed after the merge of the akpm tree, so I will add it
> there for today.

I changed my mind and applied Arnd's patch instead (see my other reply).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__28_Jun_2013_10_36_55_+1000_IMjGVTQWWB=XkGv5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRzNqrAAoJEECxmPOUX5FEJgcP/jKOk7C/UIfJiVPHMJE321wy
o1gyt4RBk7WH+vtVJzeaVzDue/O3T/B1X5VJsJqOPXOIvHk6uNVQq82af69lCznX
IQeEfO+ikOQ6v3+JD8/Am9im4mBVcvq1nd3HNHx7GUXeqfm+TB7jiPbwNIehlZ0J
CMHtCvZ6PTE/YEhNdKdb8XQz4FjuVIu1l/r/8uL70iD/GfXm+1lFbYhLVdQIM0FR
5yRPr1L3HQEzeWJoozuWJJh5L763Oo/cHz/lEg2UBxFHuV0575ZDe/jzolyieF6O
Eb9vD0xEjK1SVgTH2/6UWTx6KoKCPaF5Qwq/04Oj69DHAPZPlnwNVfrOkl044UN3
sFaX2FknMy37ZqxsZHKV9xrFR6Cw2QxEPFmSlUZE9D3X+JtXQtqB6UURloRHA7hv
zPKKAyko+JjduPHKAX5LmpwP58a9harG5b1zsna0uuZvFEG7UWHVIDBxj90y+7uB
obHf0ttxEpJUnlSB5e0tGb1I4ZrSTKTFaWAly8hH7LjnABquhmB8svT5jfTHREBD
12EnGGVfXvkc4ivwPQgBiEPpN8CyaQPGZt5GyNtXqdSLjT23hGP0hl2iTz/Mr7TX
+luzLpUqleU9h62KEoEpctT2dok5kCAd/zLO7cEyliOcidUWEMuqYZh2tfsbwQqh
EMLPypfQ4+pROxz8Fgo1
=c0N4
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Jun_2013_10_36_55_+1000_IMjGVTQWWB=XkGv5--

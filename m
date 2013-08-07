Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3HGF7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:59:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51968 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab3HGF7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:59:19 -0400
Date: Wed, 7 Aug 2013 15:59:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-Id: <20130807155917.506c1f7b67002b3c6728d779@canb.auug.org.au>
In-Reply-To: <CA+icZUX-gyFK4kNwnbqwOUzM9_T9hhj+AKufUfg8yJb4kQ-pfA@mail.gmail.com>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
	<CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
	<20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
	<CA+icZUX-gyFK4kNwnbqwOUzM9_T9hhj+AKufUfg8yJb4kQ-pfA@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Aug_2013_15_59_17_+1000_fIsYcV1+_yR=jSus"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Aug_2013_15_59_17_+1000_fIsYcV1+_yR=jSus
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Wed, 7 Aug 2013 07:43:59 +0200 Sedat Dilek
<sedat.dilek@gmail.com> wrote:
>
> The refreshed patch is from 02-Aug-2013.
> So why did next-20130805 and next-20130806 did not have it?
> I was reading for these Linux-next releases the same: "I have used the
> ext4 tree from next-20130726 for today.".
> I am wondering what went wrong.

Ted did not update the branch of his tree that is included in linux-next
until now.  Presumably he was doing some testing - there were other
changes in it as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__7_Aug_2013_15_59_17_+1000_fIsYcV1+_yR=jSus
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAeI1AAoJEECxmPOUX5FEWKwP/0f7g8CM1cJNNZsfg136XrWQ
Xdv6UNsIVhz40sS5TIOEa2nzWrtFBy/BFAwWsv01gXEpdI0fvAd154Ii47OMGXSX
Px8TJ2BUIFKkovz6dJXsAtUNkUvDkwdutfbzti2Fern2pygTlcUh6FoCcBeKErzA
/AswYXAx+JGNkYfk9wzOXToVqfPBjHShZ+Ho+w+qNshhc4fSLhVmJWjyhUxD/cf2
WcTvPxCspueJjcsBQ7NNARaJaNQbHzNzGRAwVOeNf8Xfshy63BpMx7tXPKLTTIY9
HkJx9hOa0NEvfUpO6/gC9kTEFGRB7CFIWfpQZEG77ZcVgUyfzu4zTiJ0A/+uRMjR
auGKL5IyCTarlbPX26bqjKbYPWAvBkdCePRpxbzxeSySh7Dd9eRfOz0TOuiSn14E
m5X3ksZhYspVSRzwB8FJp9QW4PQWh/3Waz2zqWlH5Pe4mFnbb+3ID0sNi8wG+fsq
rWVrywrpXNFOtjaa6FwRg3xzAxJ0miW0xqlVEG1P/UaFm7QsMdBAGNxO9pvVpln0
kHDMSC37DfVOicX+qOO/062C9Woopb6kXe8L7IfigIju60PVp5Vn6PlDHwpNfNDG
TxE/bSiWj+T1yp5mY3+hsCNqxAY4droXJX4Ebfavoqa8ykeDa++6PmsL6b8D7RJl
fvu9f41HJBXP1g/E3cyF
=A/JN
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Aug_2013_15_59_17_+1000_fIsYcV1+_yR=jSus--

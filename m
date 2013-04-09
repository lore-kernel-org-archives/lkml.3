Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935726Ab3DIN7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:59:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46025 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3DIN7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:59:52 -0400
Date: Tue, 9 Apr 2013 23:59:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 9
Message-Id: <20130409235941.11eef57a42cb97efec72f037@canb.auug.org.au>
In-Reply-To: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
References: <CA+icZUX-RMW=pHzhOumB2_R99BRAf2qGC4n5bzyLqU6pOCMDFw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Apr_2013_23_59_41_+1000_N0civPg3Dupc0DKQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Apr_2013_23_59_41_+1000_N0civPg3Dupc0DKQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Tue, 9 Apr 2013 12:56:46 +0200 Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> This version hangs... I started in rescue-mode and see that udev,
> premount and init scripts are run.
> Currently, I have no glue why when what...
> Lemme see if I get k(g)bd started.
>=20
> Unfortunately, there was a "quiet" boot-param for grub2 here but it's gon=
e.
> With "text" I don't see more.
>=20
> Maybe, someone has a hint.

This is probably the known problem that Al Viro is looking at.  See "Boot
hang due to "pipe: fold file_operations instances in one" in
next-20130408" and  "Re: hangs on boot in 9984d7394618df9" thread on lkml
and linux-next mailing lists.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__9_Apr_2013_23_59_41_+1000_N0civPg3Dupc0DKQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZB7NAAoJEECxmPOUX5FEXEoP/2vOoxyxHXX20x3xJICm+YjH
KQ7fjD0fblSi4K6pIUO/A14GvvVPWnB0Nd+QsHNAZBi9f0P8xeWDdiANNS6/DKZ0
CH4tu0VrUH76vFuG/RqP6C+RQ3ges9ahH2xsK9g456ffmwBydP1GS50Rw+7W54CD
G5XaAS60D6PmSyuKfnkVvl32Zr8qqAgPaJd/9Ov1fIvJiBq/OmwJ65Y5jlKnAqEv
k8AuXIX4jpXw1mxsIivEdQoOwnQOuQU9SQfggi70g27V1H4X1oPqPwhsJoZ5Wwoo
TEZDWHqI1IG33Xz1iyeEM9n3e9A5W1+FBBr2xNi4okX/neVF/JVGpF6wKBpBP86s
JYGA9lNnrTHfvAurZy4pzxK7G9vNcxsdO3j02DJa/FQKVwNsYUEyDQvRkROmQZj6
1LHgD3aUotQBPGosMbc2UTdT4+3f2uvdoQ5Mxk2tOVt4vRhnFZC/0RwPcN5cP9OC
a0hn67W6u+sQ275LKeBU81tKqmE+9bBKRxwnrMQavbe+J6TukPC7G1rx3pWp0XQS
1n/C62w/vJqbjHw4WnqwgFyTVXMN+P8DZVy2pDXUstS8dBuLhQT2tv0S4z6kwXUi
hQQtmohkzanUSzko0jxSwY3SJnn1Ez5BveENdB9ljcXliCCjLH3Icn7eSqqIUEWH
B9a0kzJaRjUC1f0ctYf4
=s1vU
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Apr_2013_23_59_41_+1000_N0civPg3Dupc0DKQ--

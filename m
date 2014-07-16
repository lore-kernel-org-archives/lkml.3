Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbaGPNWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:22:54 -0400
Received: from ozlabs.org ([103.22.144.67]:49116 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbaGPNWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:22:51 -0400
Date: Wed, 16 Jul 2014 23:22:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140716232243.3cf8efed@canb.auug.org.au>
In-Reply-To: <20140716132114.GA17163@gmail.com>
References: <20140715132946.771def89@canb.auug.org.au>
	<53C4BF8E.4010509@roeck-us.net>
	<20140715155547.25959587@canb.auug.org.au>
	<20140715150801.7f8099b1@recife.lan>
	<20140715190807.GA26057@roeck-us.net>
	<20140716130434.6b09b2e1@canb.auug.org.au>
	<20140716132114.GA17163@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1xd+swPQc48sLkCOXYGuaEe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1xd+swPQc48sLkCOXYGuaEe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Wed, 16 Jul 2014 15:21:14 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>
> FYI, I sent the fix to Linus earlier today.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/1xd+swPQc48sLkCOXYGuaEe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxnyoAAoJEMDTa8Ir7ZwVO6oP/RpTr7Pdzx75YlLq6XH3j1YM
TRSqCGQqtdV03pFFzyiJUpHt40DKP+53nXGnK46zEJEmW7zeM+oz/jZ/502f38dG
AWDmnY51Nb5PEGc2PlYL1o48dkS3U3cPz8fGvCQmUgEOVKwIqAwK8fv1nIHA94be
mJy5H6Sn10kYLE2PAaW2Uqnx7jQRNRoZalS8onbD9zd28hSCUPlAgQnbxwk0TFjZ
5tqrfZvB408R+QFh1MEKnKsQIoVbyXfhi/9GjNp9Xg1QX1B9WL4XrOu9Nr9PuBaT
tDYEqcqb/68NasVausSCyHTqG2P0Kz+6WOCB3csvArjYcKYhf4sJgOIxsxqxssE7
vAIBvkO17tIWnonESwyWRiaimSn+qsBlrpgAfQEbxd2VH2E83BHOGuTUAcX0wsVX
aFsdSZgKPiSjKo+eKqRefttLLpx0lfb74SNmK9nb856Xv6kKzafk1n3S+/aH+OxY
bSvYapfVbjSJPOJ7kJ6GzMjHR5GZJhVu/I+zxEb5/6s7qY6J4mcT9HGWbv9RSC0d
rBEg4rssvS/DqMJtprTZGlG1TsKoTMvPyLAsFWZjPNOjY8hIZnKaV1+i74G33UP9
IQ8CjxTpoxT30tnHHJjd8FySnrwA56jRge6P5+vUNqND0hpf9+Gz7TWZDZkwxrQo
vYm2DbXPylmhyLsaT2ua
=XvaL
-----END PGP SIGNATURE-----

--Sig_/1xd+swPQc48sLkCOXYGuaEe--

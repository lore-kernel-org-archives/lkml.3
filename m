Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab3GSIUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:20:32 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:32851 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab3GSIU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:20:26 -0400
Date: Fri, 19 Jul 2013 10:20:24 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] irqchip: sun4i: Remove wrong irq_ack callback
 implementation
Message-ID: <20130719082024.GA5106@lukather>
References: <1373121329.13289.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <1373121329.13289.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Axel,

Sorry for the late testing,

On Sat, Jul 06, 2013 at 10:35:29PM +0800, Axel Lin wrote:
> According to the datasheet[1], the Interrupt IRQ Pending Registers are
> read-only. The implementation of sun4i_irq_ack() looks wrong because it w=
rites
> to these read-only registers.
>=20
> This patch removes the wrong irq_ack callback implementation and all the =
code
> writing to these read-only registers in sun4i_of_init().
>=20
> [1] http://dl.linux-sunxi.org/A10/A10%20User%20Manual%20-%20v1.20%20%2820=
12-04-09%2c%20DECRYPTED%29.pdf
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Maxime,
>   I don't have this hardware, I'd appreciate if you can test this patch.
>   If this patch works, I think we can just drop the patch I sent yesterda=
y.
>   ( It's "irqchip: sun4i: Staticize sun4i_irq_ack()"
>     https://lkml.org/lkml/2013/7/5/43 )
>=20
> Thanks,
> Axel

Since your previous patch was merged, it generates a merge conflict when
applied on top of 3.11.

I guess you can rebase it on top of 3.11, and then you can add my=20
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR6PbIAAoJEBx+YmzsjxAgPxMQAKUkI22QY7cXjN6oHBX7BAAW
5cCT+y8DkgXUwqoquVuOTbA/ebv1wz+3NfOnW1dtbpmPncTa6K69g1+VVsEHxlwS
+8muoLI53iLoFgUb5ODnR3b7NyyCobzOEP3Z5Zqi1e6vtjUCCpF+tf2LbkVufXbt
FxifKNe730GsgfEd6ZnafO8JSMP7JoWcid08dF/BXpjy01KFtVbl1CfeXsDaPEQZ
NOttFK+U68abMVKjWzjFl/bV3pvgt2rob2/GIFo/2RVYiJmG3Fz1gj5pzPz8WNpl
QYTTrvaTQdygsDX7K3XMj0liGkjo/R9btBVgY5XyLEGXQdeCtChI+5ZvT8ynoBjz
ozMe/twTNlXUY38dTGDtxFLi2N9ToX4IYHT68NeQcGOuZxmne7qjWYtj9KXPtpwi
LRVitnIGh6DASt93RlP8esdjGMz/Fw9QcxhzhyvInCXuPsORULGRDKFyoJYL64UT
gecRfL5oqBCPks6eVlI5lyiFIWsAmQWLdlUUpFBvtzx4pXbqANHGUMJ+SW0tvW+g
5gkwg/jYwFp+/Bd72hr6jUMCO7EXyuWuhRFZOb4ihl0qMnItH2rd9aSryd6dPZ/l
uBJ8WBNw2yEnETjwyDvR20W9XhK7PQE2H7gt34ey9/W1ySYYtOKDSuGI6ZO2++Oy
Ju0xa4EDCc3sAB4xT5+d
=xA9N
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--

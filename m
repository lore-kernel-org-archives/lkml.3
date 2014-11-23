Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaKWQVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:21:30 -0500
Received: from sauhun.de ([89.238.76.85]:43190 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaKWQV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:21:28 -0500
Date: Sun, 23 Nov 2014 17:22:29 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v8 5/8] of: i2c: Export single device registration method
Message-ID: <20141123162229.GA1303@katana>
References: <1414528565-10907-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1414528565-10907-6-git-send-email-pantelis.antoniou@konsulko.com>
 <20141121014631.C86D5C413E8@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20141121014631.C86D5C413E8@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 01:46:31AM +0000, Grant Likely wrote:
> On Tue, 28 Oct 2014 22:36:02 +0200
> , Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>  wrote:
> > Dynamically inserting i2c client device nodes requires the use
> > of a single device registration method. Rework and export it.
> >=20
> > Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>=20
> Acked-by: Grant Likely <grant.likely@linaro.org>
>=20
> Wolfram, this patch and the next one only make sense in conjunction with =
the overlay
> patches, but they don't necessarily need to be merged via the same tree.
> I'm happy to take them, but am equally happy to have you take them
> (assuming I ack the next patch; I haven't looked at it yet). What is
> your preference?

OK, now I had the time to look at it, phew.

Is this targetted for 3.19? Then you can take it:
Reviewed-by: Wolfram Sang <wsa@the-dreams.de>

There is a minor conflict caused by this patch in i2c/for-next which
should be easy to solve, just remove the irq handling.

2fd36c552649 2014-10-30 15:59 Laurent Pinchart   o i2c: core: Map OF IRQ at=
 probe time

If you target for later than 3.19, then we need to discuss again,
because there might be other i2c core changes coming in.


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcgnEAAoJEBQN5MwUoCm22xoQAIwYwLQpx3DWnPiYlkAL3Eg2
zTs6odMqXEvK7R7GPe8owC4rUMwfqq8wRe97wcmK8n5miNsYOm9wK2c6P1kMYo2m
4rs/+xW6zEdcuqL+SQRpVhzdtekyzqxwylWpwBdTb0hwGRgpgogkiIc+CXG1Vrds
1IpjpDTKiujbzmCTx6v3er/XxLjCn18jWfBzyZgpUEscdNHuH0n6mPilemxuuUBu
M5UFpPgvlfwk+cIgQPafpR8MZeJahstbRrBzWIz/L0ReyuIrCPmkme1qA9/ym1u5
EdGxmx1sZOe8JxXWlbQ7OoSytDkK7N+fKHLmitGRESTGUAiXhhdlnmp7WB8JIVTb
MS6c0iyRb5cEN7gv0Y+F1VHg8xyz+LAc9gwPxYYBR9jUEGZTQudRONcFbGB0dWLP
q6mH/JmQlPZJWTC5G/fbgler9OZ4T/OP1uL46h4BulDFER/E6lZ1tMrpXHWnBlWD
CHitO97/v41YYfIGosL0g9HNb2jseNi0RC30UmLK97vRhSZ1A1+3Txfi514qfTg0
DL6YVcppil/VI6zNi3gbVCQtQrs9bjigZ5tTDWptA+IoFCdL29Q48EyqzS9532wg
NtTbyKN37RGSTB9Gd4IlZHgHPtFhoT5LblUqQPtZy/GNOIWmyC+toDy4JSDZ5K0y
MjeHZbmVuOP3eMC+wrV/
=sIg1
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--

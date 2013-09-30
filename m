Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3I3X1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 19:27:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57240 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3I3X13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 19:27:29 -0400
Date: Tue, 1 Oct 2013 00:27:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20130930232705.GI19304@sirena.org.uk>
References: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5248B9BA.9020003@samsung.com>
 <20130930095202.GY3635@opensource.wolfsonmicro.com>
 <524A0369.1080101@samsung.com>
 <524A05DF.7070008@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bzuizT9vlVVqWfw+"
Content-Disposition: inline
In-Reply-To: <524A05DF.7070008@samsung.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] extcon: arizona: Get pdata from arizona structure not
 device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bzuizT9vlVVqWfw+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 08:14:39AM +0900, Chanwoo Choi wrote:

> Additionally,I have a question.
> As I mentioned, extcon-arizon driver don't get pdata from dt parsing.
> I think extcon-arizona haven't operated without pdata.

It should work fine on Wolfson reference systems and anything cloned
=66rom them (it did when I was working there, that was the intened goal).

--bzuizT9vlVVqWfw+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSgjGAAoJELSic+t+oim9/iAQAJAaxc/n8Rq0qDxVrct/H9X4
Zds+0CJDzRMwIPI2TiCaQeLW1mSOLmzfnreShc8E42M67FwDa/nlynio7uoJmj0H
jNU8toJLEM7C7H2JeJxOADCdUvt7J4e/Nf9xjBSXK/2LZlCXNvpbLY+nDG5IOrSJ
rY/jo0CUzoWB3Momj6CH5IEy3nsLdMNP0/9WJwAcg3VTA4S4U9CttN5mEpHip8LR
d5ILb0i2A6+5TRW9wyUkzZZUPFW/JA3asiae8JG77e5TZkaiM8tBmPNGQc7a6MB7
dLPeZywkbCeLs5O8a/OuAfzxO6zWGqnNsJYKUUkSSRu4U0K0PmS1SdDIhiwahjsn
p8Gmn2hwROP0rA4xGylVm7YS56IkTLahYG7CV0JP/3AzPliJZNOajf5V3mu+Re1D
BQwFIo5PKQrzSN4WsHZArmWgnz7IRXn6e5nijN4PvaJ816bC0SwDTBXophDhjMwp
NovI1RcpTB/yjy9RzgU7HhdCx4WFLwXTJ1RvKknkb0MslkUgpCd+oNjpzCAWEZ/X
Ko+B/W0sm+iNXGEiNEvptOED6lQcZsEyrZ3Jzhl9KkXKUleTibhz5QiMJNnxDOib
CPzw631Oy/H872UxjP3DopB9nRPpKK5iNZDVjhxGGLWQwJbY1x+ByCaLviuAYq6T
sHFJMaGqRtuxMRcVqw4E
=lYOC
-----END PGP SIGNATURE-----

--bzuizT9vlVVqWfw+--

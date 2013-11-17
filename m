Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3KQMSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 07:18:22 -0500
Received: from sauhun.de ([89.238.76.85]:56744 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab3KQMSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 07:18:15 -0500
Date: Sun, 17 Nov 2013 13:18:09 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: khali@linux-fr.org, jacmet@sunsite.dk, hskinnemoen@gmail.com,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] I2C: busses: i2c-eg20t Do not print error message in
 syslog if no ACK received
Message-ID: <20131117121809.GC3093@katana>
References: <1384678731-10399-1-git-send-email-wernerandy@gmx.de>
 <20131117110846.GA3093@katana>
 <20131117123902.GA3834@awedesk.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <20131117123902.GA3834@awedesk.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Is there another reason why pch_i2c_getack returned EPROTO?
> May be ENXIO was introduced later?

Imperfect review :)

> I think we can just replace the -EIO with -ENXIO or do you want to pick up the return
> vale of pch_i2c_getack and return that ?

The latter. As a rule of thumb, it is usually more sustainable to pass
through error codes. Overloading them should only be done when really
necessary IMO.


--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSiLQBAAoJEBQN5MwUoCm2+UgP/2/1CErMmb3RXSPvRX6o6opR
l/5v/Igm1aqIvfnD+CIru0doQrMTd44fv/m4vhoOpiZykByj67FaRiw6o5T1jI34
zHpyRP3vLEPI3HrMAKK/QyVFET4gZ5wskri5Fld+15wHU1Ch4eXDj3Qk0TQ2qlm3
7Oh1XGfX1BbwKQkmBzRY5LpR+BHmhJNFlpG+nww/JBzLyRvRckJ8ekb3QMJnC9ae
etcmkm1o5VotVAHxF/Hm/zBC7yPNuXEsFCeYVP4/RyAf8D3655JqjRul8wZGCGbi
0ybgHfq0c9Y1SR85OpegPoNZ+3Ao1YEDJP6a0ecOKLXsPByKB+Rxyq4OoI04j3EJ
Le+lbT8GMH3n1rCr+RjquJ7/ti4JuDefHob3rXKwNiSY0CVbtM6k1GSHPT6gKO3e
Ts0d4xHVQXasjD6QP+oWeSTWdhuuq1M6F434kocuxNxj5QvB9QqI/V+DZeEb7iC7
tNy8IZAseRLvi2Nxy9G9qMXmIKMhAw26h99Fo/IqS08nLCkYPrMBABJAMZ+ufnvA
BjMuAtDnRXsi6AutD5X4Zg71ThaFlJC9SoV1ticvhjzw/ZnOFdtnjqUnvNIQD753
nSIBkOHrPDw2Bnrp5IQ7WfcMsQvCmVYl9WeZhDXVSTriEPcri0bv919LRqA/eiWw
5yyI4QPAOPiQWdnMx1Dg
=FLZV
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--

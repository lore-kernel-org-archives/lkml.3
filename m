Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaCFNRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:17:39 -0500
Received: from sauhun.de ([89.238.76.85]:55797 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaCFNRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:17:38 -0500
Date: Thu, 6 Mar 2014 14:17:29 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: David Howells <dhowells@redhat.com>
Cc: wolfram@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: Add message transfer tracepoints for SMBUS
Message-ID: <20140306131729.GB10657@katana>
References: <11165.1393507178@warthog.procyon.org.uk>
 <20140218205418.GH18768@katana>
 <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
 <20140109215002.25590.51609.stgit@warthog.procyon.org.uk>
 <19542.1394111635@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <19542.1394111635@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 01:13:55PM +0000, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
>=20
> > > Can we have something like this for 'flags'?
> >=20
> > There's a __print_flags() which should work.  One thing I'm concerned a=
bout
> > there is how do we handle more flags being added - does that count as a=
n ABI
> > break if the printed format changes?
> >=20
> > SMBus flags are basically the same as I2C flags, right?
>=20
> Hmmm... __print_flags() seems to append a string if a flag is set, and do=
esn't
> if it isn't set.  It places a separator between each string.  I would pre=
fer
> something that emits a single char per flag or a dash if it isn't present.
> Are you okay with that?

Yes, that's good, too!

Thanks!


--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTGHVpAAoJEBQN5MwUoCm2iYAP/jERFdR2Loh6n0FTty4AMJ+2
qjT9/0YD5efux/5zkSh6MofepKtOOooJFKeWrygbQF80vXLMGKklXCO1h01oWN56
qWxOdlFs6oT/bQ94U6XPmR4i5qA+FgJEeHeDZS8pZAuptu2q9B2Xr0SI2EhS5gzl
53PoxIOpA/O4vVpwoMhF9Q1Bqy9nCtqA6x5sc2jgNEAuWXPxTShKKsAht4T6S/rs
/UqJBLX28MWTINsFELauJFZ6hbb1ATEiGXC8Itv2PEkmiTEYyVEV5Qy1w6syOSyT
wKM+Oudlfx45W2nbdTt2/KPg+/8xbgdc5UA3ZR9I0263sztnovwyRzktfslbsZqR
LmZ3PTKOM45PnJSh3bmcskTWddMATwnftpJwJJbSw6tMhXlqxaExEsI9V9Btjnpo
8NoFhCx4bKqgIW6J0RUf6HJzmX25LVjs+IDklIGTiJGsFKHpLhBz4JVzmbN00sgo
w0mOpedMB0sJ3l1has3xc+ZRzNvyd1UkeT57YEV43nK7W9CBMgHlTMDr9/EPnSfi
g8NIVs9os/agseT+nm6e0KZ5kzIpNciChyipgA8x7BwqPyOrVEte5J1YUit22YQQ
Y8UG/hEwOQJvkbuksHVbhbL6J6M2f2bq1i0PIzB2k9taeMzCbfRYsfj9OUTqdZ8n
CEDvsLZ5a5KgZ+L2K4jO
=GYRK
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422AbaCSKUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:20:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44714 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166AbaCSKUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:20:37 -0400
Date: Wed, 19 Mar 2014 10:20:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>,
        "'Fengguang Wu'" <fengguang.wu@intel.com>
Message-ID: <20140319102028.GV11706@sirena.org.uk>
References: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
 <002f01cf3291$02c7f7e0$0857e7a0$%han@samsung.com>
 <001401cf4309$d7fd92c0$87f8b840$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NViGQE2ZneVULFjg"
Content-Disposition: inline
In-Reply-To: <001401cf4309$d7fd92c0$87f8b840$%han@samsung.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: dbx500: use seq_puts() instead of
 seq_printf()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NViGQE2ZneVULFjg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2014 at 09:26:17AM +0900, Jingoo Han wrote:
> For a constant format without additional arguments, use seq_puts()
> instead of seq_printf(). Also, it fixes the following checkpatch
> warning.

Applied, thanks, but please in future send incremental fixes for
already applied patches.

--NViGQE2ZneVULFjg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKW9oAAoJELSic+t+oim99ywQAIoVdgNr8nE2kIcTH8dwsv/h
ztG3qCTTprrI0M9yr4JTTG6XSomWkqNY4RnRTRp7dyqZSbjbAmPgdDAUN1naUQjw
pMpxuy0yLd9UFtNGOFsEtPAfJry2RdmiVCcB/qObXrlIgcjTEt2nxAGZuqhaBr19
SVjxb4jnDy6hHaSv5JYGmbGjyGN81lcTL31x+VJC5l6RXBy+/1stc7wc2QvKq5s2
4OzHheEQpCaoO8EXHwqCZpArjHX6tnlGRQJPGzxAcdif4NG55ZRHlP+iAgDdm4pq
NtvlxIb+Zm8YEdqrbjhJzwrO3qO6w9QcrHKTZDDRttLR7MlVRXfOTXqO8aJ4lNUp
FQ3IW9PBKf7loQi9h5XgIo1aulNmc2WL58Ao0ftcRWChY3rTmbh7xRCyJ8EgcTcj
qHmu24quietJl5YQVffiampDED2U//f5kqeQjktguG+tvdel9uGXwjGhws2HYUPO
cGJFHr5oeolWeP7YL2KE5mR8MHxQwraCMaLHGKe+Ded7ou2XARE8dEFw60By+WJX
yyQCDFG7s9LcwH4BWNWNTQHvgxqh94aGBPV+NlpXYZ7nzk+JOO/UIHruKhGQo4kg
zNk7Z3E86gG3S16NFSKLPdS9C7ycGWhCmsFtz/2zpxiOfuUHWJSfZzVvXyHdmpRI
HMSE5q3DI5mHXEVqvxD8
=/Y/V
-----END PGP SIGNATURE-----

--NViGQE2ZneVULFjg--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab3BGRnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:43:16 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:44016 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab3BGRnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:43:15 -0500
Date: Thu, 7 Feb 2013 12:36:30 -0500
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Linux 3.2.38
Message-ID: <20130207173630.GA8355@roll>
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	Hmm. I'm not sure what's going on here but ever since I upgraded to
this kernel my CPU use has always been at 100% - various apps (top, pidstat,
conky) give different reasons for this, conky&pidstat claims things like
X/the most active X application are cpu hogging, while top seems to think
the majority of cpu use is being done by 'sys' - the interesting thing
though is that my loadaverage is staying very close to zero.

	I know that this is far from a useful bug report, but to be honest I
don't even know where to begin checking, so I'll start a git bisect of
3.2.37 vs 3.2.38 tonight and see what happens.

Tim McGrath

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBURPmHpEncCrqzVruAQIrAggApiHZV7pqh1NOxlBJk+8J8Fh6LZhcFUwV
KUqWS55GeI95CkzeqStPX2m4pq8P3Rs8HUQYXpm4+PEnb6hzv2ZDfky8rh/wdkG0
dMLaXINVIF3fRgIlfgK8hQfHs8MFUYQ9/QfEtGJA0d84Vg4BCEYQnorIYbc4c8gq
s4xLjdZqsolSZaL7oLjtrDDDjB79R2XbzLxK/Yxn5ufi0M/APJa8GSf6zODRBZE3
AkNG6Eaqc1Q0wicJUAP1lzwZoJebjjXC46upxTMraUVjZx+yxFitotINLUCN/vE+
XJy22oxgxNQJrHKntAqAztS4LrYsJAmigXviXTAdSNpHKsLfi3Dkjw==
=061z
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3CDUJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:09:39 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:63475 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab3CDUJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:09:35 -0500
Date: Mon, 4 Mar 2013 15:09:30 -0500
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dmi_scan: Refactor dmi_scan_machine(),
 {smbios,dmi}_present()
Message-ID: <20130304200930.GA27246@roll>
References: <1361037634.5374.437.camel@deadeye.wl.decadent.org.uk>
 <1361037742.5374.441.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <1361037742.5374.441.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	Forgive me for bothering you about this again, I know that -stable
has a policy of only accepting patches once Linus has accepted them
upstream, but I'm curious what's going on here. Is there something I could
help with to move this along? I haven't seen any discussion about it since
Feb 16.

	Of course this assumes that I have not missed the patch going in...
Tim McGrath

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBUTT/epEncCrqzVruAQIOLQf+PuVIeqhElxXwNfy7HJPXyXhGd+RDz7nt
PeqhJmtxAp4hRyIpZ3K63zd5siJGZox8SfFKoJbgPvlfjIRhYru1krC8rvGO3HwP
Xn1RhI73yJTfyVIRy0p/+rqKDFeLEiKAZzUCs1420m7REccmiAQdhQqvlS8RsKqH
uGoroM+EHuE6u43RryBzw2lXgYWUGET1Imus6Kmp+DDA7CMZWHE3eCzwicSxX/rW
yTZbNR72CQeQMlLNPrEVSQTrjhYfF/8n8pnJWvICdnuleLVxvMJSFr6Q4aC5vTfL
r6Ygok0hDnBmQqo59FHkvbMTr/28NVoeoO9AWS6mjJzKq3ZcXyMqqQ==
=6+h9
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

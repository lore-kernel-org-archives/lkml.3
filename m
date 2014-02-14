Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaBOKJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:09:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60555 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBOKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:09:18 -0500
Date: Fri, 14 Feb 2014 21:19:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211939.GK4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-13-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P8VDRTGkfyc6BSVj"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-13-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 13/16] regulator: mc13xxx: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P8VDRTGkfyc6BSVj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:59PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--P8VDRTGkfyc6BSVj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/ohoAAoJELSic+t+oim9/SMP/0JH7sw2RkUKNa8JXYuyUBjs
pi8rOk+nAASdOJRy3EUDf+Dgd7TytMKDFR3m4T+iNlrm0GYnS8UQJBQ11UgCNnWm
m8JaGDjWTe6Vx5zM28CpykvHtOnRS3tt9yb0qAiCDgSArFtKdEBax+UqIDL3UX6w
dAMdHeBlGFHnD13REEcjTD5snQbGiRWF9zF1bMuFk4hWZgGJsKuCzqYdvUedn7oM
4R7yLjH28g1YKZ2eZDGlVH2ACR1YrFGdASEPQMPRyQ1TCG/m+uoCqY6W4lCxVny5
i8um37icKOfZPGM0NwPsgMbgDf7QDcKMO9ercuJRQlJgLF1ZOBEvapKKAIzOZ+1A
Fko8q3FtROX7zzPVYEe5s48rQW3qutF7WDNgrjSnfALCLQ9tDZLaceuyhkgi5I5U
9Mk4pIQhKAS4w8+/Ynp35IbC5Mrrot0c6vDfXOzeflb1ZtaDuEPII2k3RPUQG+5U
ZYhOw3/OLjCIptNWBsc7jUWfP+Mac3snc+RGANzjsWRuRBG4Y35Gc/FvG0LShm3O
y/ivisVxyYE7oQ5bv54CHB/b07HY3kyhSc26gho3RllqUgnnapyt4HyezGtuikUq
awdmfINlwUM1OGqJMj/FhmdMiSbNr2ZsfRXp/dj8Zcniv0qVjDeyf6VGEiV6cQrD
wL76cbqWEVhXqQ9EUB0I
=CnRO
-----END PGP SIGNATURE-----

--P8VDRTGkfyc6BSVj--

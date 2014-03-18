Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaCRMih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:38:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58952 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaCRMig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:38:36 -0400
Date: Tue, 18 Mar 2014 12:38:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140318123832.GS11706@sirena.org.uk>
References: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Iuot8e5drzPqTM+3"
Content-Disposition: inline
In-Reply-To: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: dbx500-prcmu: Silence checkpatch warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Iuot8e5drzPqTM+3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 03:53:01PM +0530, Sachin Kamat wrote:
> Silences the following warning type:
> WARNING: Missing a blank line after declarations

applied, thanks.

--Iuot8e5drzPqTM+3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKD5FAAoJELSic+t+oim9h1kQAIHUoYYkCNbFX6EyHh9u48QU
vOvCUqYoSzb9HnBw7qwyhuNMn7QsVR9mwLBCXCVcSkNcEqc69pAbXNZPQ+X+hIH5
kN62mjJeXTY0sUnFbCex/q48Ma/KSR/ybipuWRhcF0rw5WaKP5nA4qL8Tjj6eiEY
4IJCRoP5L7gFkRi40W3yrppY6mp5bQ2fz3Y3jGSARk248z+Ee/pIlJzmSUaOWIzg
JrlU+kNh/W43hRtz2TFWTSYxNVB+bFCuvYjlo0EeVoQU27tE7z1PP3niuxDKtb7q
12JZwQ+GGgAEQoot+3Q5v5dfKgTI73E87cstineE19umhQ9OZPSYsNIvVdXZwDiG
NpEQIJhb35ACXqyqJ7gtcH+43+gIMBjlb/Ok25orl/0E5f7o1nOkc7kIxozgPOai
Qj7czSeWzpQcHq9Wr8TSF4+lHU5eezJnizkcFRbAHCUU8x1PfpDFCU63FQ4mr7DJ
gmS2DReW4TI+wdjPgU73VlR9AL7EM3qJlE6ObfdJAxO/rsV83ttLY4gS4Knvj4Ej
gGTkzshG+Xp12hEnRACpgweHt/mfY+YcovNeMwpRf6i3fzUSb5ecghkDzpztVuEm
wKLjLGoyc9N3uvxu64jtN7wn2EJJK3VE5UnVAuoepYLtgi6QnIhkNKlB4K4u2sv+
i0RD1B/bqaFrBzbXmojf
=jccV
-----END PGP SIGNATURE-----

--Iuot8e5drzPqTM+3--

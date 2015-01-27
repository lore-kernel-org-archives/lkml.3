Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbbA0RgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:36:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36530 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbA0RgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:36:18 -0500
Date: Tue, 27 Jan 2015 17:36:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, Songjun.Wu@atmel.com, peda@lysator.liu.se,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20150127173604.GC21293@sirena.org.uk>
References: <1421739797-25988-1-git-send-email-voice.shen@atmel.com>
 <1421739797-25988-2-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="71vIRUdx5Wzj+PCo"
Content-Disposition: inline
In-Reply-To: <1421739797-25988-2-git-send-email-voice.shen@atmel.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ASoC: atmel_ssc_dai: remove clock pin comments
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--71vIRUdx5Wzj+PCo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2015 at 03:43:17PM +0800, Bo Shen wrote:
> As the clock can be get from TK/RK pin, so remove the comments.

Applied, thanks.

--71vIRUdx5Wzj+PCo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx8yDAAoJECTWi3JdVIfQYvEH/RLXh9GDW1VdqdTM5Bet9mML
sQZZhcrEDxW4eZKa/Rx893P/KN4AEUEyJjwRv5WCp5uPm+0T/JZctuGD1K+LLkNv
2gGTeCB5MP7WgYICq5bhEu62lINgWBG9PTIo9IUA3MShX/kzqbAMid62RhmqOOFq
meLsourfQ2gc0GbDkVwaWIARm1NIp+dAjwTptQOhrV8NR95icMhVyvrRXCqikQPv
tUAbWI9XhNdSKBVyAuZTeLOqfn35AwYVbTRsqGZKaL2RnnWNgHPBdKTb5qT1EWiM
5dEMGg8v6DvmS/P0WZhLrjkx1MIpdVMSgyOysSn+NwqlH4ZOWAaFbs1K9BoqhjE=
=1CSa
-----END PGP SIGNATURE-----

--71vIRUdx5Wzj+PCo--

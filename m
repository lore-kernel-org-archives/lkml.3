Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaHDKol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:44:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaHDKok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:44:40 -0400
Date: Mon, 4 Aug 2014 12:44:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chintan Pandya <cpandya@codeaurora.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3 1/2] timer: provide an api for deferrable timeout
Message-ID: <20140804104426.GP19379@twins.programming.kicks-ass.net>
References: <1406793591-26793-2-git-send-email-cpandya@codeaurora.org>
 <53DF51D2.4090002@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P031Sa4wWaDYwbKN"
Content-Disposition: inline
In-Reply-To: <53DF51D2.4090002@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P031Sa4wWaDYwbKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 04, 2014 at 02:56:42PM +0530, Chintan Pandya wrote:
> Ping !! Anything open for me to do here ?

Give Thomas a moment to have a look, he is the maintainer after all, do
consider he's busy, and he extra busy because the merge window just
opened.

--P031Sa4wWaDYwbKN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT32QKAAoJEHZH4aRLwOS6lcMP/AlFRyGvHguMpbKmCNx3EPgc
DWwmwBbXfpsc3XM4UjP4VpNcRzBrux7HC+twa4amoQEhwHp1H7GhGOywtwH64u7q
/X5lP1vTNqOEgBahlxiC1nihOytHu26sAoV5Fq7QtlIoEXzbcQnK5CHszL4uT7f2
l4okrKe9LFzq1e+d6KAPvJuDqdLoWgIQSMZa95wi4mLur1k012vRP7un+8+aDrrJ
yM43CTJ1Af931yIZXUmlLhuIYhrVQrT6HGvVT1KQ0D6e0kJiOtVfgxC0XZweBU1l
5izb245HtrA76hWIC2nKMduhGnowbOM28cR67U5yhe02skZVEBwvo2dsF4k7H3IQ
ncTZAOpJ3o5dnwQiOhhSeMicU9e7aVI5hSC8Cm0Q3oMle0f0se0DHYBKjoCwAZRI
ghezObPl6qLE8+QX1Cr9d5aBCSlLw/A00p5shZIMvw5aLwc8TWF+5FWtyolQQMT9
p2tkiPAGNjAD87rpWdl5VDD+WrCuP2Qu+PpokOT/9+3gp7sJziwvb5ky8ZtUqAW9
/eJrUtBGIJe68vU1iIMVO0jQM4kH7HhV0q1q0cSxAKwC3sA+wfYDxO79qfxRZk8r
gWcci4TMEFjZNc05SZPm8opUm3iVy+9ZVcVGxPn6ulehYgd0EHVhSO6h8kYXjTo4
Orfyb3v/Kv7DFahBz5s4
=861Q
-----END PGP SIGNATURE-----

--P031Sa4wWaDYwbKN--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaE0U2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:28:12 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53898 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbaE0U1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:27:31 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Fabian Frederick <fabf@skynet.be>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix busted pr_info conversion in kernel/workqueue.c
In-Reply-To: Your message of "Tue, 27 May 2014 20:44:33 +0200."
             <20140527204433.e22e1cca95d2b4a5dac5f960@skynet.be>
From: Valdis.Kletnieks@vt.edu
References: <14251.1401215339@turing-police.cc.vt.edu>
            <20140527204433.e22e1cca95d2b4a5dac5f960@skynet.be>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1401222429_14392P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 May 2014 16:27:09 -0400
Message-ID: <25551.1401222429@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1401222429_14392P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 May 2014 20:44:33 +0200, Fabian Frederick said:
> Hello Valdis,
>
> 	I thought Tejun directly reverted that patch (Joe Perches noticed
>  the level problem just after submit).Anyway, problem is solved now :)

Tejun - can you see if that patch in fact got reverted?  It made it
into the linux-next 20140529 tree somehow. (Perhaps the revert is in
a tree that didn't get pushed/pulled correctly?)


--==_Exmh_1401222429_14392P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU4T1HQdmEQWDXROgAQIZzhAAqnQLMNoOhtkKovDjqR1RxTpc2GteAUrw
HEwzD73KKPtz4mw4ECQVU7D2IFnfXqVK9QA70oUQnkEm7H/mdk9HzENpiYKIoH7/
HbqTJdVhGxctmlFv1egx0ZOuMmbgkXG6SIN9fkIAl3UASM8S6pGqKoypHEK+E4II
mBhd62h3ysCEneuzc5LKdwFvGYHDUcfYJ3uxO66W2rsEzL3gw77dV0hgzu1fnZAl
bazMEFVZajirj4+E4cLjMzlSFv8c0tH+vIWKFbUdQAuf94zHajCvPDG31OnIo1fh
PXk6ya36e1kWcHowPf7OfySxz44JSlQtagMUdotXSArTa4d8gAhoOritJerMVBjd
cDFwivfoWCMxI6XL9NvEUvMIVsdR7pq38M8I94spv/km4un43+OHAxOJS2u4cO2R
4kjkRllF5/PptANNMfkx8gjo649NQltxU/DyjJs2NeVZZqFpu1YdsGpGwCUGt9Ye
YCM6EfpTKlRDASEQQemrXyKt2DwDK6cDZZZkM6RjOr9FlpNIMZol26hqONk86VnY
PyQb664GtWYYfTi2MMY1hT4O3FDH4lGonx0p0jg7PsNG/U/tsYq79P9vwxGskwOB
+a7xS942aNgmbpe4EBhbOVw4Uz2VRg4vJT4Xw5tHCXQG7E2wUkbonV0PsBzime2O
6Vd+I7F+tfY=
=PyZa
-----END PGP SIGNATURE-----

--==_Exmh_1401222429_14392P--

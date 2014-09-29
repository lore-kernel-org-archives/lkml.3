Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaI2TXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:23:20 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:43335 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbaI2TXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:23:18 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Catalin Marinas'" <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        =?iso-8859-1?Q?=27Uwe_Kleine-K=F6nig=27?= 
	<u.kleine-koenig@pengutronix.de>,
        DL-WW-ContributionOfficers-Linux 
	<DL-WW-ContributionOfficers-Linux@sonymobile.com>
Subject: Re: [PATCH resend] arm:extend the reserved memory for initrd to be page aligned
In-Reply-To: Your message of "Fri, 26 Sep 2014 10:40:54 +0800."
             <35FD53F367049845BC99AC72306C23D103D6DB49163B@CNBJMBX05.corpusers.net>
From: Valdis.Kletnieks@vt.edu
References: <35FD53F367049845BC99AC72306C23D103D6DB49161F@CNBJMBX05.corpusers.net> <20140919095959.GA2295@e104818-lin.cambridge.arm.com> <20140925143142.GF5182@n2100.arm.linux.org.uk> <20140925154403.GL10390@e104818-lin.cambridge.arm.com>
            <35FD53F367049845BC99AC72306C23D103D6DB49163B@CNBJMBX05.corpusers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1412018518_2318P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Sep 2014 15:21:58 -0400
Message-ID: <15815.1412018518@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1412018518_2318P
Content-Type: text/plain; charset=us-ascii

On Fri, 26 Sep 2014 10:40:54 +0800, "Wang, Yalin" said:

> I am really confused,
> I read this web:
> http://www.arm.linux.org.uk/developer/patches/info.php
> it said use diff -urN to generate patch like this:
>
> diff -Nru linux.orig/lib/string.c linux/lib/string.c
>
> but I see other developers use git format-patch to generate patch and
> submit to the patch system.
> Git format-patch format can also be accepted by the patch system correctly ?
> If yes, I think this web should update,
> Use git format-patch to generate patch is more convenient than use diff -urN

'diff -urN' has the advantage that it will work against a tree extracted
from a release tarball, and doesn't have a requirement that you have git
installed.  Having said that, somebody who has access to the website probably
should update it to mention that both methods are acceptable....


--==_Exmh_1412018518_2318P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVCmxVgdmEQWDXROgAQJ8Aw/8Dn0LeCawFXirdyHOs3Xko9A21ez4vIQ1
n15/VJf6JTgVmqbBR7W+oKG1qPipw/ladt7YNKnOJqwGpu+Gj0azwRZjkQKwZepV
7fijIkb49Hx2T1Wwmmr/0qCroihVoxwGpdj22oyxhUpXXjtuwIhOxso7v3BoeaFU
FCgzURL+n1uGCB1uoh4N4E54/MbOUQa/bBJnNiDc1g9FRpXAOMkchOrG661uLbAc
qRxJdJgfS06KwQ9KPLNHMbFU+x+8ngY4aL8F9z/DlZn9Y0ZWzCB0+8gSVlcUk1Bk
Tf3OMs/fpmbl/YUtBtiduGBoy4gr/4W427JceEk6jTEMuIXcKs6dHzShryDcKhas
W4mcZcrQ48O9d6ZdwZB/Wa7M0R4hi6hN3lUh0a1884Db7QLfxotMfCfNQbW79P+K
cojkR5PWHVlMLbnPISuZkC6Imoa4ylnSJd3U2Zy6jaZ7paUAsj/BaFVFxwata41e
l4OKMJIemo3FFJ/0NvLvEZ4HdfBTLO74Jz9zfIU9q98/FJfnQXSNynViJzaxabhG
EdSkoluI/CkVttjLooYAUDNY/dTmvdowMUsOU+5h7xJtWf+XndIMl7NN+6weHoRV
rSbqOsvZDxfLjFdNKnedrygV1qovfH2o62cXYfJK00ERFypchVZ36NdlqovAIwst
9ve3thPVwd8=
=4N/Z
-----END PGP SIGNATURE-----

--==_Exmh_1412018518_2318P--

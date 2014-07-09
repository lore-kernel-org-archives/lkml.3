Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaGIKOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:14:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:58577 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaGIKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:14:24 -0400
Date: Wed, 9 Jul 2014 12:14:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 01/12] sched: fix imbalance flag reset
Message-ID: <20140709101413.GR19379@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TS2hpMIFW5hvDqU7"
Content-Disposition: inline
In-Reply-To: <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TS2hpMIFW5hvDqU7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 30, 2014 at 06:05:32PM +0200, Vincent Guittot wrote:
> +++ b/kernel/sched/fair.c
> @@ -6615,10 +6615,8 @@ more_balance:

In order to avoid labels being used as functions; you can use:

.quiltrc:
QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"

.gitconfig:
[diff "default"]
        xfuncname = "^[[:alpha:]$_].*[^:]$"



--TS2hpMIFW5hvDqU7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvRX1AAoJEHZH4aRLwOS6NGcQAJ4kfMCnv2yah0o1FfmrURUw
phVrDu6+L7dePfjQsapbpDX2G0mNmNhEjT1ntOIL2VbOhTrD9kUiPA57U/zcbh07
ibywHLDVr4GccYV804auKBDRXusaQ/PT+xpO2Ir8F3loovKSYBOvXpfRtR57r/yz
kuvkQGOzE8kf9lNDfEUQPeberFFRdc65AYMT2zZCbWCF10wmJFZcIyFogcrpFoLO
6nCdw5GzjIDYo6fSzWCNo1USHQ9zeOuW1THOg6mMO4u822SlpjDNsKaTgJ/XTvG3
w7+3JHPRStObWNdmnOTr/po8gUGaSogebKHye7+VvH2sTD6dSxbxpw/tkmEXloso
OY16W/yl2PT+cKrnPQri6pkoReQDR/SJleY6FDwhcNCMzOqHUft6mmg+g8CA26mf
hVpvHtjTLitZu4OIZ59OUVG1M6PVfYqtvwOA3TMoqxkZnCZXy59DrgIcgSwqeSaK
fMWolC1RNk59vxLygyEGy+TKsMx/ha+kuXO7Ub4/PtX7Sstl5R0Epzedd34tlInx
OqHK3XerHY9m7aDYHts/vLouOA0HgFAyedowxWi11QUfbTb8NEi3iXL0cCgfZ463
cJzxmDc7jBeec/HTXYUmYlo6ADXVz/GSagt/Eq8QyupXuuQEvBnXz3/WtJPjgJnv
TIT2IftL9KLOjdNDTNgT
=QwRr
-----END PGP SIGNATURE-----

--TS2hpMIFW5hvDqU7--

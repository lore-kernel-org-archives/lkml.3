Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaHNKvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:51:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:49007 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaHNKvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:51:49 -0400
Date: Thu, 14 Aug 2014 12:51:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drew Richardson <Drew.Richardson@arm.com>
Subject: Re: [PATCH v2] perf: Handle compat ioctl
Message-ID: <20140814105135.GG16043@twins.programming.kicks-ass.net>
References: <20140617121328.GO3213@twins.programming.kicks-ass.net>
 <1403009029-30967-1-git-send-email-pawel.moll@arm.com>
 <1404230760.25766.5.camel@hornet>
 <20140707124315.GN6758@twins.programming.kicks-ass.net>
 <1408011468.21373.4.camel@hornet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ahP6B03r4gLOj5uD"
Content-Disposition: inline
In-Reply-To: <1408011468.21373.4.camel@hornet>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ahP6B03r4gLOj5uD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 11:17:48AM +0100, Pawel Moll wrote:
> Has it managed to hold on to the ground between the cracks then? ;-)
>=20
> (asking because can't see it in your perf/core branch on git.kernel.org)

Damn this patch is cursed; I've no idea where it went. Lemme stick it in
perf/urgent, this is ridiculous.

--ahP6B03r4gLOj5uD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7JSvAAoJEHZH4aRLwOS6tZoQAJcjmrpjbuv5FqwFH5pL0Udp
jwnNVBsSjdm75pxgaxICiQ9snHaRtpSseCfKv5qMAR/+ddSE03ykRPSkYyuwRLtn
SPs8EAfzrE3NJ7e0euTbKfwH+TYz59VpBoJP4JAO3gNl7rF1Ag8Ou7+Dit/YvViv
ue7miVAzixvOMfwDrx7dTMj0ATWPnDkGzV3YNRzbcUegttWp49tn+A0i43es1ofa
xWj1ADTnwyBCi//fXVDwfxhTsGPzEKDt4mt7ixhCmZZhHiDjnSl4/xHlSJqmCIU+
8pHN82Jg83QoPjrJ7hellhqFeLF8t6+7YlKQs8QIvwLcmTvLY9GA43K8CWT2K75b
foFCjggJguAMFTMB9pcjSqyHWEy+1wQ6wW0AB7L9wLg1qh7QPoGqtAuGhh1t7A9u
hfYWLkVExxIX/wA8uQXOam0MvQzkINyiyodaoudmaIBQr8jx7SE+mxq65LUzBPzp
tCZPJmmM/xuRPAkIkvM13NBZvdIGpKhVfzTZKB6fTpOrSmMw+xr92oz1cK35Nq6H
03SzXIluEDj7yrKtj/BIePdli1Ps0zYljkrevs/RfpV/Bkt2f6vQB2B7oblgEcvw
AfFsXnXtq/uzfmr77e5BEhnWJ29hV+m3GQfeGk8L7HQDETCDhx3JajSspI9/fWqR
omqRMVfhij46qctR/NuZ
=yZXp
-----END PGP SIGNATURE-----

--ahP6B03r4gLOj5uD--

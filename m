Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbaE3Pz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:55:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:53289 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaE3PzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:55:20 -0400
Date: Fri, 30 May 2014 17:55:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Jean Delvare <jdelvare@suse.de>,
        zhangdianfang <zhangdianfang@huawei.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Binderman <dcb314@hotmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] toosl/perf: convert "==" into "="
Message-ID: <20140530155509.GC11096@twins.programming.kicks-ass.net>
References: <5387D6A6.20703@huawei.com>
 <20140530144446.1b4586f5@endymion.delvare>
 <20140530152011.GA1202@kernel.org>
 <20140530153729.GE7427@krava.brq.redhat.com>
 <20140530154709.GC1202@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dbdikjxO6Hyl7qA/"
Content-Disposition: inline
In-Reply-To: <20140530154709.GC1202@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dbdikjxO6Hyl7qA/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 30, 2014 at 12:47:09PM -0300, Arnaldo Carvalho de Melo wrote:
> Find it attached, zhangdianfang, please send it as an attachment next
> time, also please CC lkml as well.

And here I thought attachments were frowned upon ;-)

--dbdikjxO6Hyl7qA/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJTiKndAAoJEHZH4aRLwOS6YQkP92exBfYwBrPF7vvKwRaL/esh
AkA0w6YgitNu9sua0zRc1y3nOGCR5xle8ShUuwi/Oo1Ay0VL8AbYuR/EoSW7NK9f
U7HLzN/Hvz8UjrukgWL371QHLTiaHN07dyrmCXT7PSO2qKrUfp6EeP/cZYk57DXU
S/8P/gFdItTnqWb4efeMzYnfxdSn/+TEq0IBQLdwn/KIoH7OxVpUPqRU7/IOKF4z
aDZc0qVpBlaBKDgm8e0qYaTbl3bBCGSnofOZdMsUiAgjp9JX+4me+Lcyer3z94IJ
HBlQoxVzkVtVvtxfeBmebWjFUpCnp+vo7lMX+0Gy6okYK2LNhsPGAVACJvZgv4Sh
FfJ5H0DOKDI8sA0/txF/xDGYn+OI6bXb3PeNKqBjLN1KDG/Tz9258xWm5FHwNVhC
dHuVUqCgyl5CNqeRw4GtgNVbRvjGYjrP5Y4uvs/YieHaY9H1NHbqiXfmNbpPR/Ve
E+xHpnu9wM2ja8iSsN5oG+MSqEm1Jdeh6+4Xfz52r6Tzt8qpYQidI1lgpwIPZ//2
WhWTCsEpa5VzflyKLf1UNM0V9VqUuVImuFKvoSm6uBL1OhBt1nPK61aqh09sfQc0
/zhVV787pfm0mGwdQe8hbDW/5luyd0oLX/JljLCHwjwmfYwkr087D+KxdSgSiV9f
Z+dNJMQRI56ktY/X7+k=
=2lK7
-----END PGP SIGNATURE-----

--dbdikjxO6Hyl7qA/--

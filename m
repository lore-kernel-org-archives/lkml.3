Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3H3OuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:50:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43257 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3H3OuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:50:07 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        kernelnewbies@kernelnewbies.org
Subject: Re: [dm-devel] [RFC] dm-lc: plan to go to staging
In-Reply-To: Your message of "Fri, 30 Aug 2013 21:33:29 +0900."
             <52209119.3070907@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com> <20130829033023.GH4872@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1308291043410.20142@file01.intranet.prod.int.rdu2.redhat.com>
            <52209119.3070907@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1377874041_2619P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Aug 2013 10:47:21 -0400
Message-ID: <50810.1377874041@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1377874041_2619P
Content-Type: text/plain; charset=us-ascii

On Fri, 30 Aug 2013 21:33:29 +0900, Akira Hayakawa said:

> Candidates:
> 1) logcache
> Not too long but explaining enough
> but looks little bit dull to me.

Descriptive but dull naming is a much underrated quality in software packages.

Consider the package HarfBuzz.

As my daughter put it, "Sounds like a bad coffee name".

rpm -qi harfbuzz says:
Description :
HarfBuzz is an implementation of the OpenType Layout engine.

(And don't get me started on the people who name packages enca, fros, serd,
yajl, or yaml.  We aren't using ASR-33's anymore, brevity isn't as crucial :)

dm-logcache works just fine for me as a name for this.  Or dm-lcache.



--==_Exmh_1377874041_2619P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUiCweQdmEQWDXROgAQKOJw/+P1nyFNS7Ky5KV+J8glshuUtyp5z48ZDZ
gJ+bSe3s78ve91qyBXfck9609faVxs9WmgtfHzhZxHYRiUVlOfnywIiOVwB6igvT
BwzZOFISOMofXVdTOK4vHU+lKOdw3pUdWrhES4keG9j5Gh6t2uAGI1wPQjOmFmng
BWaR54OVyn+RlRoRf7AD1BePKLMhfYYEdV8F89TUoNazsIk9JjnOPa7pXe9CHis/
XK+GOl6yuEjBTxAAyQ45tygorVvtWQuCtxHl2drc91JinV0tZGkoeGXUcyZHl/C2
wH8iI1ncq7REdxlDK76COzab6NoKG67X9DhbVSruT7iijef1ghcBvl5uK6n1aesy
8IoSGIKwLyLRnH2BJj2KpkvIy5fD+GKr77sWaYPvmDKazjYgyh2aEvVEYzPZvh8M
iFhjCPb6xW6IH2+akaiJMSrh2R5P2wLCKeqj4VsCPtxJ6Z99YweM9HnS8K1G2Wrg
LtY04ZK4Puu43mbnSnjtfm32tCNFylr3BnJ+mU00nLNwSkkrdK64qCfRCb+n+5aD
L3U/nhDZjw0GoG88LpsjAbTb8IZ/araGJkOsJztv5rY7gqw/1rMJA0RTNalkHYKG
NvZZ+gi4JdUUtwWPKr83qHLwsxRygxHjrdMzQEU/fu4VZbLzneVFuLhfkkrgxJtW
oynvf+2S8nw=
=hp9l
-----END PGP SIGNATURE-----

--==_Exmh_1377874041_2619P--

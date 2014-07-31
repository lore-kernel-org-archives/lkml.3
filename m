Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaGaHtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:49:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:45909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaGaHtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:49:51 -0400
Date: Thu, 31 Jul 2014 09:49:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v4 0/9] perf, x86: large PEBS interrupt threshold
Message-ID: <20140731074938.GX9918@twins.programming.kicks-ass.net>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
 <20140731072744.GN19379@twins.programming.kicks-ass.net>
 <53D9F1FA.6080106@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="15Rf4wGOrHmWCZoK"
Content-Disposition: inline
In-Reply-To: <53D9F1FA.6080106@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--15Rf4wGOrHmWCZoK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 03:36:26PM +0800, Yan, Zheng wrote:
> On 07/31/2014 03:27 PM, Peter Zijlstra wrote:
> >=20
> >=20
> > OK, so no feedback on the 'pending' discussions we had wrt PEBS record
> > generation?
> >=20
> > No feedback on the correctness aspects of the overflow crap?
> >=20
> > Just a new series, which I then have to dig through to figure out wtf
> > changed?
> >=20
> > A quick look at patch 6 reads like you still don't understand the issue
> > right. There are no 'collisions' as such in PEBS record generation, or
> > are there? See the earlier open discussion.
>=20
> I'm sure collision only create one PEBS records. Actually, the patch desc=
ription
> was written by Andi.

So now Andi is contradicting himself:

  http://marc.info/?l=3Dlinux-kernel&m=3D140129731708247&w=3D2

Bloody wonderful..

OK, so someone write down exactly how PEBS record generation works,
including the iffy overflow register, bring it to the relevant hardware
engineer, having him sign off on it, then come back.

And preferably add it to the next SDM rev. How is anybody to use this
stuff without knowing how it works?!

Let me try and figure out if actual collisions mean we cannot
reconstruct the actual events or not, you do the same.

Please file an internal bug report against that hardware (if there isn't
one already -- I've only been asking for this to get fixed for years
now).



--15Rf4wGOrHmWCZoK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2fUSAAoJEHZH4aRLwOS6XGYQAJ5Xuu7zusSCnvqM7zYr96M2
5vLD5YvOTqvxgWt0jW1UxDvtFetrftCvIaw60P1VW8LVwgvN94Sm1Rhcs0b9kP8l
EbXVV++PV4aWk/VpW2MQjTpvyL4RL/QZHD51v4GZGhPp+w50JMC/reletl8EtCe2
2Ky/qEqUDp/AbIWGrGrmG5QHIQEuB/QgFTR5aAC6m2EpmztYFs8U5UNvR8gqhJcz
GnM5VB2PfegLPUA7c1TUQwQzvD97JiUvKoS3USYh2HXotr31ky+dom8cNDXoqt38
iDLc+G05FQEswf+2pimK3vbs6hi0a6jR+qHP+mehWnGH16JF/qtmsYFFl8bGQJtQ
AQti8S1HbKl03GmbiB9p0IhMn9s2tmLtF7pOzc9WGt42T/250GaFHPQGLfwjOTuN
L/A3t+oNN4Dxra9yCvaKTnIDa6yjYkqvSVl+TocQscXKsGkPa/8myYQTUIUjltnt
BXadK8cyV22SszwdHNc8V7skZqCZiOMuXLAToJruMqRtg98AwMnlJIUhW88bwS34
CIYghE9GSjRlBlAXh/69tGQ8ZEoG+jCizhuioRd1SeEz5m6YmVEn/qyc7ygikT5k
IRiOwAuP0UoexUx4s7lVhNcdHcVS9ORqmjLEST7FL0xImGi7ncOqh/lQhhKXbXr9
yta2HdObtNTLOJTBVap4
=IL7C
-----END PGP SIGNATURE-----

--15Rf4wGOrHmWCZoK--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbaGYCGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:06:13 -0400
Received: from mga14.intel.com ([192.55.52.115]:44519 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758802AbaGYCGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="364459570"
Date: Thu, 24 Jul 2014 21:35:12 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RESEND RFC PATCH v1 0/70] Gloabl CPU Hot-plug flag _FROZEN
 Clean up
Message-ID: <20140725013511.GA19206@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 09:58:36PM -0400, Chen, Gong wrote:
> Back to long time ago (about 1.5 years), Thomas began the work
> for CPU hot-plug, one first thing is CPU hotplug flag cleanup.
> Paul hoped all the _FROZEN variants of the notifier actions
> can be removed at that time. Now here it is.
>=20
> Patch 1 ~ 69: remove all kinds of XXX_FROZEN usages
> Patch 70: remove XXX_FROZEN from the kernel thoroughly
>=20
> Not sure if removing XXX_FROZEN flags thoroughly is overkilled.
> Fix me if I'm wrong.
>=20
> P.S. My last post is banned because of the capital Triple-X in subject :-(
>=20

Hi, maintainers

Until now only Boris gave me some comments. Isn't interesting enough? Or
I head into wrong way? Please let me know. Sincere thanks for everyone.


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT0bRPAAoJEI01n1+kOSLHf7sQAK03i6J3HIpQUNPP+5AsXS5C
LKAeBqMzLWUDH06bzrj0Tj5jEMAXdRr5EtA8Z1CzxNUGRtjwwCCXZzO+KH/v9UyJ
oOZw+17y4GCju4UdWvTs7fpnhQ9kqZ9dZpDZ2W6n4Grsbzlvo5DtI/9x3G41goS2
1bnnverjX2NjJlTox9Vlc4e3dW6wB6H3u1xqeo7Jdk/hZv926IOU1KAzOdr1pXji
oLKAS1JYWmpcuJqc+KmFnFszzUBaotz3GcTuMk+xtmbF7Y9tfHJ03G1g/HjLOkJc
c7xVVC/+/dkxUoDKhaHEtxUOt1mBKvmJFosLI0NvDD7Q+GnNP5eVD/tdN1u1GGWN
/20y1aY5+uJ6go1zezj6VL3+DfiAcvO9Mbc9xZjdCoVRi54E4nIz2gCpv0WWFF3q
Wq5CObGJFQgnJ48l8OedZ2ZzSx+hy+td9sI3J1ES7CQgNeD0btRaxbp2nt8sakAY
ht5gihXWyG/te1hJa3gxpdOD0eHpPc9FIvH2zqatPvh2q2QYLAfzRTQCIqqQ2hwV
wCvjhMpTdSM7KYN5DedwizxCpSzbxOi+9fCgp0Qc5GzjmbjpSy+ZO4Iucf3dgLNL
mrPnG+weg+6EBRPCOE2YsxWp4YKnl4ap79lTTGjiazpJsrnboMYm8PMAH/hu4rwj
+QOsd3gVyifD1fMmdmFf
=63Ec
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--

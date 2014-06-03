Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaFCMPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:15:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:41249 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbaFCMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:15:17 -0400
Date: Tue, 3 Jun 2014 14:15:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, bsegall@google.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com
Subject: Re: [RFC PATCH 09/16 v3] Define and allocate a per CPU local cpumask
 for Workload Consolidation
Message-ID: <20140603121510.GI30445@twins.programming.kicks-ass.net>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-10-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z71G5GnkLsv0QeRF"
Content-Disposition: inline
In-Reply-To: <1401431772-14320-10-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z71G5GnkLsv0QeRF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 02:36:05PM +0800, Yuyang Du wrote:
> We need these cpumasks to aid in cosolidated load balancing
>=20

That's an entirely unsatisfactory changelog. Why would you need these?



--z71G5GnkLsv0QeRF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjbxOAAoJEHZH4aRLwOS6LHQQAImJdF6zGbBXX+KT7EIl66/H
47DixyUM6eLz26l1ExCX3D1d1h2QkZwY/s6XEDz3RISNqUGTiXnN5sDoUCwgIFWA
azjUS2ixWB2bB2Y7WBWncfgoVxtr/GLqHzmeOYZKRvW2VZt0uM6ASBjvE97f0HDj
+ocmgSl4+YAHJNWvmsZH9eGuGXJkqgtn6/pTKD9STB/U+t/hsYTJdudqvg8B1s50
u7seuHurwuEcYOFhW/R5RgZqf8F9N2lx8HzqEZT5FzJbsPY0WyN2SWSXG4n3Wg/a
VJmuDoG3tm/ro1Z64AziKB0z5p6PDqvXLjNqDDPRd0LCJtVboF+0/l2GafuBQaTj
OUiYlzrlVrjY+Z/+27OBmhmY8QFng+aA7c4LhRwt8sXnKOdznHSA/Wc1FAFmOkeB
dYnLNH0wuEFG5qZZJGdco3L+UVkmf/90glPfhAuxpI7TKRjymLgPBZGnYBdUGQSX
zlGoIYms2LsskpHFtGsKWen7fJRcKxVACkFVPbsiQs/Ya+wsvcMg3YsFudHW23CN
N3g7qGlHJmMCTMz494ofCTR7DuDgQOcemiar1RTyCULbRH7RVnXAmiDDS0sp9GeQ
P8c1GUop9B+Zy2qqTyw9GUQG2FabcT2N4yiyYcKNZKNyeU7fydbkm90ygl7zgKnP
KXMrBwDPvuU81LAdIdcQ
=iSWK
-----END PGP SIGNATURE-----

--z71G5GnkLsv0QeRF--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbaGaH17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:27:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:45818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaGaH16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:27:58 -0400
Date: Thu, 31 Jul 2014 09:27:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v4 0/9] perf, x86: large PEBS interrupt threshold
Message-ID: <20140731072744.GN19379@twins.programming.kicks-ass.net>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XJ5PZ61hszgMzeEB"
Content-Disposition: inline
In-Reply-To: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XJ5PZ61hszgMzeEB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



OK, so no feedback on the 'pending' discussions we had wrt PEBS record
generation?

No feedback on the correctness aspects of the overflow crap?

Just a new series, which I then have to dig through to figure out wtf
changed?

A quick look at patch 6 reads like you still don't understand the issue
right. There are no 'collisions' as such in PEBS record generation, or
are there? See the earlier open discussion.

_WHY_ are you sending me new patches without sorting the open points
first?

--XJ5PZ61hszgMzeEB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2e/wAAoJEHZH4aRLwOS6c3AP+wftoEnX1ovF44cuZ2E97zb5
eu3yd8VfPUWtG6DilUCla1huRvGrwmqQqDtftbJdIk/5YC50LSTAb0xz0qNPeldD
iCA/cQ+y8RP0DLjENGKoQqrFvHongbX4xqrt6uP2VPvbdZlxSGoAz4ItQj5gNKXX
8y8CxE9K2k6bE7sNzKpwBJjEw8wZi9OgYaVI+Xr0kdznoCB4LjiQnNPChOHtBU9H
GONb6JUnYOzUIHFpx1Q6ATh+boRZdktTHbVZfFCGbOiPKoed22JcN4ptkzbSDUzg
QrFXu1iXH0eA6TMG1sVCNGrgoDiu0HIUNc0f0ttULcNrHhb5YE5R/OmJGLjoZuU4
qknFUxrYzdJM9JRtXccbrTN9v9R1CRMhFY5hFc+Ac4gRlafpIAhZGoL6vN2xIZ6u
VZ6wYAmmKttcZvkJUUIRvro56uxHEa61Qjc0I4ppUotWPmvk935U6hEWLHQ340Px
gHefiCr44m22xyliE+qyxEx649W9Er0efrCBIAR9MQl13+jGe47g+rlpySd0+N/U
jg1HldT/UKZgEPrEHku+tRm0n7YGEwRfPFEryaXGC5DV7aD7msx8iZGivng2iRzK
U074wwcFMrvUxmq0+2um5CUjcYz8OcKFZ4WDvdxqKXSH8pK/XvHxyIiO4HUIO3A4
m/oxW6Kqdbjkw5UK3Olq
=DZva
-----END PGP SIGNATURE-----

--XJ5PZ61hszgMzeEB--

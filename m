Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaFCM1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:27:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaFCM1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:27:19 -0400
Date: Tue, 3 Jun 2014 14:27:02 +0200
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
Subject: Re: [RFC PATCH 13/16 v3] Intercept wakeup/fork/exec load balancing
Message-ID: <20140603122702.GM30445@twins.programming.kicks-ass.net>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-14-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gK07V1xo3z7kEGDf"
Content-Disposition: inline
In-Reply-To: <1401431772-14320-14-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gK07V1xo3z7kEGDf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 02:36:09PM +0800, Yuyang Du wrote:
> We intercept load balancing to contain the load and load balancing in
> the consolidated CPUs according to our consolidating mechanism.
>=20
> In wakeup/fork/exec load balaning, when to find the idlest sched_group,
> we first try to find the consolidated group

Anything with intercept in is a complete non-starter. You still fully
duplicate the logic.

You really didn't get anything I said, did you?

Please as to go back to square 1 and read again.

So take a step back and try and explain what and why you're doing
things, also try and look at what other people are doing. If I see
another patch from you within two weeks I'll simply delete it, there's
no way you can read up and fix everything in such a short time.

--gK07V1xo3z7kEGDf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjb8WAAoJEHZH4aRLwOS6oOsQAKI26ZCB9FRgjaYeVHLoa0+z
iap1EvqblYx19ew9ph7mzJlLHwUCcPWaD9ZiSzSYDnhFfZ7TR8mqfvDyzGnFkIbD
zpGVoKZRG22NerM9udYrsuNZihXo8WqMh5FbtX3baGoLDWgdIKOb/e+LQhaiy1Gq
WJJNwhjKEYT5tzNvTWXPd8sTKbL9Nvb6r7xhSUGBnBXDbRxa3Q5vryk2+nrDqgwr
KvalXbVH9Jm/HB6VVUHa6r/V6Q/LJfz8BkW9UqC9kgXXfQhYl+OmADLQC8UMGJcH
tH/O/scwJDBtCyj0SUSDbGrT8/mHpf6SpSah3kWvm75WR9FhKJpkxjbb1wOIq5OD
neMmV4sUT0wjtdP+XXAb1Tfr2iMUu4TegIwl752tplO5fJpey0sjnklXAu7mnaSM
TqQ5TZGZVbWgwxv0E7PTaEoQsKHdRw1SECL0KN8cweSzDWGn8XdWcX3+U/seKgF2
uo0P/ZhdoP+rmNbAsEi8OHpb1OkFGIrZZIQILzSIa2Yq6lvFtRfYBVyVDMK3834A
36rEY1+PqkNwZ1BPmpcw4Sl8SZ6lBBDTZroBe3UXF522t9OiBqWg9LELjPJVqotW
HevL2Mf+k8yGIJOW1KB5i95QZFa+XSdD6PYGfFPrFVt1Jr7iXGjFwbm8Flyikr22
qT+gEZLw59s1AU6Zy+07
=FJAB
-----END PGP SIGNATURE-----

--gK07V1xo3z7kEGDf--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbaE3QRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:17:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaE3QRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:17:30 -0400
Date: Fri, 30 May 2014 18:17:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, gleb@kernel.org, pbonzini@redhat.com,
        eranian@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf: Allow guest PEBS for KVM owned counters
Message-ID: <20140530161720.GE11096@twins.programming.kicks-ass.net>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-3-git-send-email-andi@firstfloor.org>
 <20140530073153.GA20167@laptop.programming.kicks-ass.net>
 <20140530160357.GB8876@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gtf2ElYKiUa3nI7m"
Content-Disposition: inline
In-Reply-To: <20140530160357.GB8876@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Gtf2ElYKiUa3nI7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 09:03:57AM -0700, Andi Kleen wrote:
> On Fri, May 30, 2014 at 09:31:53AM +0200, Peter Zijlstra wrote:
> > On Thu, May 29, 2014 at 06:12:05PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > >=20
> > > Currently perf unconditionally disables PEBS for guest.
> > >=20
> > > Now that we have the infrastructure in place to handle
> > > it we can allow it for KVM owned guest events. For
> > > the perf needs to know that a event is owned by
> > > a guest. Add a new state bit in the perf_event for that.
> > >=20
> >=20
> > This doesn't make sense; why does it need to be owned?
>=20
> Please read the complete patch kit

Please write coherent and self sustaining changelogs.

--Gtf2ElYKiUa3nI7m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTiK8QAAoJEHZH4aRLwOS6BaoQAJBUajATnd+KW3rN628dNu6d
QxnI9eDz1bzD8/UvhEvHyAO3rTxv9yVhCFKotR0J9p/QkmGpCRun6oQfchqd36T+
5Fxod7CbfcsE+jpHUpFMW5q2pNWgAhPMfvc4YZQZoT41ExQMsGrpP32EgIIehfeK
ADP3r3//NCCt4F59hkJ6oIQD7YwufRrG2b1WSIeRrFDwWcRBqkq4l3hN3dQ3aWSa
luqX6PuoskpFn7G30QYkOHsQ/rqVcYR+XWZNo6LPq8oAM8lQC8rWoAI5KIO5rzI8
GOakvvrCSrx+KcvHJHadIXLrUaFChThinONySiXKVl2MYsFBskYcvdPzeE91NQN+
aJQwkqRZZHsOSQ4SEG0rueUt92v54DYle91w2aqNv7tDO442rjBox27DJpoJTY8S
uxuXidZZsx774hYz2JoDrKqHDmJ6WuCWWHwGUbJC0xcSrFYsKnphIVOOc4DvB2EQ
9XSyx+WOy28jqa1SKv/4MBwyrVpNOPGc0iMoA38yGNdyY+NhAVgVVFoBTwskrO/A
Nq3gPifGKxekajeO8m8phJuivAlN/ebRfKeYtiqp9zhRJNzxnXuHyPRLDmJNf/DG
5SB2AZEj1l3FT90rYaO5V0IpGG65788fuYerpJ/XFWv8TgQEis78MY5f8ttIT9BP
Bk1fOEGhL5UWx3v9G2Q3
=c9AB
-----END PGP SIGNATURE-----

--Gtf2ElYKiUa3nI7m--

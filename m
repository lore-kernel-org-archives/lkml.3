Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbaFQMJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:09:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:49349 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaFQMJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:09:45 -0400
Date: Tue, 17 Jun 2014 14:09:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Fast idling of CPU when system is partially loaded
Message-ID: <20140617120938.GN3213@twins.programming.kicks-ass.net>
References: <1402608359.2970.548.camel@schen9-DESK>
 <20140615161921.GL11371@laptop.programming.kicks-ass.net>
 <1402933807.2970.577.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S4drRqups3dkeHIl"
Content-Disposition: inline
In-Reply-To: <1402933807.2970.577.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S4drRqups3dkeHIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 08:50:07AM -0700, Tim Chen wrote:
> > The worry I have is that this update is 'slow'. We could have grown many
> > tasks since the last update.
>=20
> The update to turn on the indicator is immediate and triggered in
> add_nr_running. So if there are more than one tasks on any cpu,=20
> we start load balancing again right away.  It is only the=20
> clearing of the indicator in update_sd_lb_stats that takes time.
> That does no harm as the cleared indicator is for the skipping of load
> balance, which can be delayed.
>=20

Oh right, shows me I shouldn't be reading patches on sunday or similarly
daft times ;)

--S4drRqups3dkeHIl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJToDACAAoJEHZH4aRLwOS69+IP/0AW0439ziqhgHzyPin2mQ2+
vUDq6fPsQNvHuOvgIlPFUyV0X2NIJKLBXJd+NJ9qHPizo+u4bIRG76YLm5eYbsII
dLVBb2yysyjM3kSsg13D51tFjj7LucUG32FY7AEP8Y1sz9jhtHJjZL7kYuknogWB
RlzGMBCXqQLOe0L6Q+6NSImJpfBaBXyYgSbGB8z6ZxfWWP0IMAgG0h0Aqzpzk7ka
grwtTBX+rXYdAumWNhJ88C4KjjbRAZ5lEbyHpwuLN72r4J1aUtkuFzS3jMTw3Wnn
ydw+wtLFrWZDH9AT9OvnTIb5sC8FGW2kMOS3lKnZAb3jkbM18/FA6kDNKLZIzAii
sNc5qCK1ihukIY2t5rb2aoW9EuyYtXprDQcxCYmAsFlvcMWl+DHooxLriBTaBSI6
LEeAHmM1P11OlFZnu0sR1UOzzDSctjvwKX4aAZ6PFKolZqnfT0DIFBEAbai3XKcT
EEr64gilwS5uaCdYzpkoCbcR+ptv1mvEniG4eMoi9y1Jkq4jlmzr9oMMIKFHjc1l
uxbzgfPeNdCJaLjKeQPwPQsA+CU/ts0vNoFR0//+4011GSlOV5wz8m1/uvaQh0M2
6ZC73rJvaxB/H7gYimjWTcKXkzc7Fwn2iLS9HAvMtlsD3pf/6GfKyKarTSVR0MK0
OWqy/DBm3j+7vFhYoUcO
=8kmZ
-----END PGP SIGNATURE-----

--S4drRqups3dkeHIl--

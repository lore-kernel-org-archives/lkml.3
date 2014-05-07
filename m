Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaEGQN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:13:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:39040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaEGQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:13:55 -0400
Date: Wed, 7 May 2014 18:13:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        khilman@linaro.org, tglx@linutronix.de, axboe@fb.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/nohz] nohz: Move full nohz kick to its own IPI
Message-ID: <20140507161350.GT30445@twins.programming.kicks-ass.net>
References: <tip-72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61@git.kernel.org>
 <20140505123706.GP17778@laptop.programming.kicks-ass.net>
 <20140505133113.GD1429@laptop.programming.kicks-ass.net>
 <20140505150356.GB2099@localhost.localdomain>
 <20140505151228.GR26782@laptop.programming.kicks-ass.net>
 <20140505153405.GD2099@localhost.localdomain>
 <20140507151735.GQ30445@twins.programming.kicks-ass.net>
 <20140507152922.GB16694@localhost.localdomain>
 <20140507153736.GS30445@twins.programming.kicks-ass.net>
 <20140507160504.GC16694@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jtcAeju3WzRmRF+o"
Content-Disposition: inline
In-Reply-To: <20140507160504.GC16694@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jtcAeju3WzRmRF+o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2014 at 06:05:08PM +0200, Frederic Weisbecker wrote:
> So we can as well zap these commits and replace them with the irq_work_on()
> conversion (still preparing that).

I hear you, but I think Ingo doesn't want to rebase the tree because its
public, but maybe he can make an exception..

--jtcAeju3WzRmRF+o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTalu+AAoJEHZH4aRLwOS6vKYP/2oeT83EOJNPpi17xUEd+BQt
k5p3aC0lSBEELDl3/fMMz7wTfh9qi5hCSB6jo13tk512GqN9acNyfAPLo30IBEuM
M1tCvH6Hf555m8pk/W0fp8mVSNkHth1Suvrg5HHxiaWctSLBJ/92crFi3v4lhKLS
c4uN0/HNDKifGNLyzdzXX24FEuKCum88j+BZWHZ3Jh1RDk/okvbudj3kDKmlsEFf
3aH8zTNtcyOj/7qW5D74cZbD7N90doIzJmNZwP6fWcjGtwQQbsXGjNtwWqeIXvXN
DJhUkDaM9e2kQe2QgjKfh7RZltVcN/v4NixdIeGW09MQel5/jW/ep5Tqesh9W/oz
1EKMKpaTj6LdtMIZB9LQ/rp3X4YXPCQEQVndTxDpuPs8maipzXkP7/WvNJImb2Am
uDRDys43sA7XH2NDVkN2hBfUPWgdvEri8qPE8U2ODFpqvSC8sbWAgF6hTGr0OnZV
G1SgfUsiPToXgN0E1OdCg1Fe6TG/KHkWc1by7vZCpyG5T6PSa/EzGxfJ8E5MyWOH
hlJmy4g3/+5G7BBhSqp7uVmt66euP8DlGXdFJ/X7UWuhhnB82YmJRM1KMFgJcD9d
mgaO6EMxEw5m0hCNnPNN5a0Xay93UNXwKjoQ6Gbt3ZyOlifXV6zeNeXy+zZzZbQf
8fZDrIDB/PwhMDRFa6TB
=iS+q
-----END PGP SIGNATURE-----

--jtcAeju3WzRmRF+o--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaHEQMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:12:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:38761 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaHEQMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:12:48 -0400
Date: Tue, 5 Aug 2014 18:12:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 0/5] irq / PM: Shared IRQs vs IRQF_NO_SUSPEND and
 suspend-to-idle wakeup
Message-ID: <20140805161235.GE19379@twins.programming.kicks-ass.net>
References: <20140724212620.GO3935@laptop>
 <alpine.DEB.2.10.1408011533580.4997@nanos>
 <3855585.ek3PTQLkmN@vostro.rjw.lan>
 <3321219.itH23ZEDt4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SALzGxM+9VBgwVYp"
Content-Disposition: inline
In-Reply-To: <3321219.itH23ZEDt4@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SALzGxM+9VBgwVYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2014 at 05:22:57PM +0200, Rafael J. Wysocki wrote:
> Here's a patch series based on what we talked about.
>=20
> [1/5] Mechanism to wake up the system or abort suspend in progress automa=
tically.
> [2/5] Fix for shared IRQs vs IRQF_NO_SUSPEND (with wakeup in mind).
> [3/5] Wakeup interrupts support for suspend-to-idle.
> [4/5] Set IRQCHIP_SKIP_SET_WAKE for x86 IOAPIC IRQ chips.
> [5/5] Make PCIe PME wake up from suspend to idle.
>=20
> All tested on MSI Wind that has a couple of issues being addressed.

I can confirm it works on my WSM-EP which has that shared interrupt
stuff.

--SALzGxM+9VBgwVYp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4QJzAAoJEHZH4aRLwOS6msEP+wSxqLsjT6iMMkBfS6Vo0L7q
ZF9+D1iPaa2goWOctNY6yhP6nFjTq0xrcb5TuGr+tqKkPO9ciEhtm37EihHNDV9x
Mn70t1aDND9meiimMbmoESq7m5ixsvTcxsU047/fAElszwyylCYjM7lR/Hyac3WR
m29SfIkksNLsDYZLVhx6SXr18wANAczMWg449ftxBI9l2KUyZ8kM/9KggbolP+6K
u7JkhSRK7t/lDU8+aiqVmmwAD32viH3lF1Ldb3RTviRf+3otYK98I6Isdq7GqTmi
IDp/GLhX52yr7i5AjjPcaduNhrMA1eV2pj8Ec5h2ECak3iculmtyJhmkKs5Asj1p
xBkM33/tgGjcZrMkmQlHkpxPO6sAgL7POeIYtJykO019qgKlu2rx1RPc8c1+6MMO
vfqZj4CykLOq/A3fxrqhaAdr4278gwRka/6XW5kE3gplIGcAOIVmzaOFX6VB2Zqq
Onv8xjpY5bPhUcPCn9JyD2PSkzQUUesf3yHagRVjtHEcUxpD6k49NegDN0ceB98U
lWdk7a8KjYhAo5Jt+WHLa7+Zm0MnL0HVlQcgkkvBTV74K3FzUMb/wSBmo/U0MgcI
q6KInmazcuTmk+iit/6+IeKObepGTqbO6Iux18n68RDu/BGn+bPCX9ZiHdnoX1YY
t6Rmhc8O6oUngmLXxwYW
=q8va
-----END PGP SIGNATURE-----

--SALzGxM+9VBgwVYp--

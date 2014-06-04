Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaFDICY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:02:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaFDICX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:02:23 -0400
Date: Wed, 4 Jun 2014 10:02:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Move enum CPU_[xxx_]IDLE to private sched.h
Message-ID: <20140604080214.GJ30445@twins.programming.kicks-ass.net>
References: <1401800345-29468-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0Wb9dq0wLbp4QS76"
Content-Disposition: inline
In-Reply-To: <1401800345-29468-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0Wb9dq0wLbp4QS76
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 02:59:05PM +0200, Daniel Lezcano wrote:
> The different enum CPU_IDLE, CPU_NOT_IDLE, CPU_NEWLY_IDLE and
> CPU_MAX_IDLE_TYPES are only used in kernel/sched/fair.c and
> kernel/sched/stats.c.
>=20
> Move their definitions in the private 'sched.h' file located in the
> same place than the files above.
>=20

Thanks!

--0Wb9dq0wLbp4QS76
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjtKGAAoJEHZH4aRLwOS6pC4P/RT5fVYZXmR6xkrFyJSjWbZH
63xOCnbGPKECBYNt5tJFy7sNaz3C1lcUhU8M11e6q8AyI24GSPsMAoUW692ke7VS
jFv+SU5WAf8fNMzEX6nhmt/030RIJ9vprg+RZo8F5RVLeR5TBSgLyD8n9QEgERUI
itq528fBbRSKRFuoR2CdMz6DmKXfjadbtXFY7uNS1nokGjyK4t+Gc5XPV8pwUrhO
r34rTjjJ2qz5OMlsyz7ZBW5wl2yG8mi8M8ZraSjpuZY/emwVnyD3ltUpbgrWYXKF
aDRXYVlT9O+0sOYCRdRvylbTZTgOG5ZvTPNu4L/EtuDmipI6gOrQQycJE7EEXwo2
YYt9uq2GJjwDV6fsUolTYhkzdF5fputdgCaunEE4dh8KSB5nL/CX1IjeBU2l5nTr
kSMflOPGuN7tp5LmJr5GUhGtJpcf7BPQ06L4V6RPVQENoE31HzLANg8UzLvc3hcH
FbaTZ9pB3frP9Ck3h+6jgKmZ3qRCyW/LrC9ZhLl0PD0wigR0KoV4R9N0XxdwB1kr
eHCq8IsbfxdHQex3lMfsNvI2Sl69QPnzeIgtie0BJJgb9aa1gP54sYmbu7P6oodi
V/UqJ31As/0Id8TRbQ12ypAiX77p3qbOFGxb6dXMENS4BBrxEoEYclgYAqqaB3yh
SGFKUR29NWS4FK8gEyBM
=Q3ZP
-----END PGP SIGNATURE-----

--0Wb9dq0wLbp4QS76--

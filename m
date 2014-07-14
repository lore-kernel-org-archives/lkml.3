Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaGNIcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:32:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:50820 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaGNIbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:31:55 -0400
Date: Mon, 14 Jul 2014 10:31:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>
Subject: Re: [patch 51/55] clocksource: Make delta calculation a function
Message-ID: <20140714083146.GJ9918@twins.programming.kicks-ass.net>
References: <20140711133623.530368377@linutronix.de>
 <20140711133709.584242982@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYo4Elh1vtcYNvbq"
Content-Disposition: inline
In-Reply-To: <20140711133709.584242982@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYo4Elh1vtcYNvbq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 01:45:15PM -0000, Thomas Gleixner wrote:
> +static inline cycle_t clocksource_delta(cycle_t now, cycle_t last, cycle_t mask)
> +{
> +	return (now -last) & mask;
> +}

Inconsistent whitespace there.

--zYo4Elh1vtcYNvbq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw5VtAAoJEHZH4aRLwOS6DlgP/RpQst/kJ97O1eKbuRojR56L
RbqPpV/yoT6vuWtT7k39rnpc/mFk97cJPyuf0LbQ2XH3m6/ys6lFmpnz1+2S9gN9
zSItwjr8ycA1ciX4NvqhLh66zvqjhvFgQxSNrECc/lfBYI5bvCGEpXqRF8rTRcyD
Hn5D76J71qfm3yZIj0ddIysRhcFaFi+WfioCGD9YN7dhdoi3s5oHDYHavpmd+aKK
26cMC8IRJJvoK9xw1kIOa1/wN/x5h0Ufr8oZnfuqZufVwNVA5vxNfZZOKGEdPIwk
zbc4NaLhvdVK5IgeY26wMZBiMXvvZxJ5tedRV/y8p/RkvOGr6cMQywwWHrP1oy3b
j7VETullYJzGklIu9L5UEJaQnnDG+OakfUJ+EAubsFik/BqPk239NQbDY5m7B7+g
ZQ5cGGg8BLa4MYDKHzSxgwGRq2F5JH6jKgpDw+vPWkRvUsC7k1C8hpBPOqUnQTTo
WkC0I2WQLkEnn603NKG5c+VE4xAo89KUV6KpDto6BJrd9dJAEDyn+t0sfAtxcR7m
CPZZgymneinXqnThNYlnaIYWpciRjn3ehc7Kah1isgR7klF4PstNU4uqHRTbrX+Z
G4PvrFxp6aoVGNtkBq1srWR7ejxGLw6ym9MDfpbgYNb7iT7zEnH1HZjCxTobEARV
u5hvvkNPvW6cV+M49BJn
=i0U1
-----END PGP SIGNATURE-----

--zYo4Elh1vtcYNvbq--

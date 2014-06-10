Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936284AbaFJIWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:22:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:47867 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbaFJIWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:22:11 -0400
Date: Tue, 10 Jun 2014 10:22:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: paulus@samba.org, mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH 1/1] perf/amd: NULL return of kzalloc_node should be
 handled
Message-ID: <20140610082202.GX3213@twins.programming.kicks-ass.net>
References: <1402385858-23181-1-git-send-email-zhouzhouyi@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4PR/+zdSfVlxyWed"
Content-Disposition: inline
In-Reply-To: <1402385858-23181-1-git-send-email-zhouzhouyi@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4PR/+zdSfVlxyWed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 03:37:38PM +0800, Zhouyi Zhou wrote:

Less typing more thinking, this is wrong. You should fail when the
allocation fails.

--4PR/+zdSfVlxyWed
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlsAqAAoJEHZH4aRLwOS6kSQP/1cMdq2ixjf+HMLx23oB++ah
g0yhCodAzvnCzVi9tJFHiIeO/x0pegBxF1Rimw8tehjs9djFjFsziKM6MwKUiCT6
BMf1l9nJdFMqA25YV4/DMGwVpbuaAh82e1we8c0w8MJrKHRe4G/lm8NWr5BTN31e
kMGP7gtK07s0j9v+/7dmpabvpQ6aoAAfTAHw5hEErkRSBdOY+F/cxSFVvPGicxei
wZ/JzkYjHEBDUeQUyD5JG39kxE0OOSPl250vmQFfg9U+dRPqPvyNexXrsUNztgus
uuQQKfgCznUE8xK46h6HWJ6aXX7cKvVVL5DdLWwp6aNYcfvrzrJvKtrWmBxrC8Em
DX4/y/wDI4ZRNAgwqS+sVry2uAHxohwoFocmx+zKSRsj4DrLupeXBk24YntPzCDN
ezjBfA+ENjpKUnBxxzNkU1ooEIvpat/q8nffoswvlSUN0yHrsZrleuwJNnZEoArG
mf13ckk9R9g3e1pdkDYAShUozclo/0ke0WrxSVQm1aenwdB0os5ooCKZqX/acKQK
xTTw43x3bG2KTUkwB9o3HjKWH/Hd0Gx2IDhW/i+9BXyLzrNqJ7kBTU35t32z5uSG
Z0+mJ0Js5kUk/a0AtdydQ23UE71OzssMB7IFuC9tJCV2JkXQN4/lqpzNrv1aaITL
g1OFVz74fKXboCS7lfNR
=GkMk
-----END PGP SIGNATURE-----

--4PR/+zdSfVlxyWed--

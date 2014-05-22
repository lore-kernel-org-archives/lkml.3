Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaEVHVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:21:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:43833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaEVHVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:21:00 -0400
Date: Thu, 22 May 2014 09:20:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ye olde task_ctx_sched_out trace.
Message-ID: <20140522072055.GQ30445@twins.programming.kicks-ass.net>
References: <20140521150613.GA28702@redhat.com>
 <20140521151655.GG2485@laptop.programming.kicks-ass.net>
 <20140521153013.GG5226@laptop.programming.kicks-ass.net>
 <20140521153219.GH5226@laptop.programming.kicks-ass.net>
 <537D9EBE.7030806@intel.com>
 <20140522070414.GN30445@twins.programming.kicks-ass.net>
 <537DA2CC.10306@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="686YKZy5Vj8ja+ka"
Content-Disposition: inline
In-Reply-To: <537DA2CC.10306@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--686YKZy5Vj8ja+ka
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 10:10:04AM +0300, Adrian Hunter wrote:
>=20
> My patch was not related to that.  It was to get effectively an "exec"
> event, by piggybacking the comm event.

Lemme wake up and try again :-)

--686YKZy5Vj8ja+ka
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfaVXAAoJEHZH4aRLwOS6F3oP/3LjUygRDNZRXTm9FPd0OVnh
NenmXU4ZTXoNlpT2hKQkXL6b4ixjnOwNjtSEMsKD+O6rPKwT7Oy20QET1d4+t3np
paXLd0+PUrnAUil42zz35tq0lIlrIKkrBDh/qUKxXVxgpLdtC7ehX14yTtguTxuW
FGgY7Vic5nOS0jYRZSYLU1MstsBqFSzk0X/6BHrAmyoFnOZT3J9NcA68bl+mb1wF
FF1coCD0WNKu7NAteBdZmXhpx3eZHyeIGOj5+ivfZXLyB0iVX+mokjbgahgR6y3S
7UT0cwI5ostuhfXYEh9grddhOY992kYjKbaWW0KIUZh9elO7nWIMkyXXq4clCw2v
020co0RqlZcFNvgDYjvh0WVmfr7tsZU3F0zWbOxjCvrOIQ5w5tb5Zy7bsBuLBOvp
5RKjEmwX+pEEJczDH1ULY4jAdY/GUZFXCWBXKm3xQLzpCob92VO6E2AU67VSC7sg
ktCIFoa5lmRFk4MPi10PfpXzMpBkL9McoEMswV/WBNPQtXXEwxRa4rK2gryos55t
XamHie314wn5haTLDrSJLn8eR1bTQRsGd/kbo+gcMbL5WkYcgJYgPVpP2S8wIdGG
wZ5Nj/quoSME0mYzudSozHD1jJiDqkMGRpgmPfyIIIxU3HrSHaoMiHx2blaPoxRV
Hzgue/ZCSNbEkZl98tpF
=72P1
-----END PGP SIGNATURE-----

--686YKZy5Vj8ja+ka--

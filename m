Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab3KFW1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:27:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42636 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3KFW1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:27:19 -0500
Date: Thu, 7 Nov 2013 09:27:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error when fetching the selinux tree
Message-Id: <20131107092709.09c9e76757362bad1f1dd885@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Nov_2013_09_27_09_+1100_C1jvd30POwUQPQGb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Nov_2013_09_27_09_+1100_C1jvd30POwUQPQGb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Fetching the selinux tree
(git://git.infradead.org/users/pcmoore/selinux#master) produces this
error:

fatal: Couldn't find remote ref refs/heads/master

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Nov_2013_09_27_09_+1100_C1jvd30POwUQPQGb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSesJCAAoJEMDTa8Ir7ZwVtPYQAIFJMy52kzDsw6taaIz7vHeF
j0GqeLpjjCUeh43thfFk9ydzU75fEO3oeMawtirUWSJhPsL5Mqth4mHMJf9f7dr2
QCYvVWDs21MhHA+NOYEWK+UNoZstqw12ex4x0bT8OIrw1vnVj2gIJOu1hagDyE3l
7Z1zlDRzJ2y3ItZ7a3bgCowKOKbj2LYZpsAY5rDIgaKNPD1teprxE0CILlaVWIbQ
buCCq7kqlQcIAHkVd0qkIdaIWyDRI4bBf2tLQ2kiyHhmV9MqNb4EXRbr9r/UpZK4
p4qd0hdyS8XkxwojU9wYlJlizyJ1h7+Jgzw5AUFr8tRTPsuVoeHlqVTA6I2mB/lg
0j5Bs1bE8I3lfj60yiQW0La1RtAQIqQkajWQ3uJuAkdMF3pbs6fgK8JWPngTqaQu
t0SIE7o+UQBMtxF3gMCktnGdNhTsuuUGqtVbzA/hBYFZ8qEhBInJ9sfaC3Y24W/r
Syaq0fevzqrcZlJnu2K4IPs2IWlTOUh/eQsBBMorwwjRWmGkQfm65ZmvOZ3F6QZq
C1u0vCRi1ABx3mNUGk+RCXomX9Y7JWJet9g9vTDcf/bjIgcnACyeBPAtk6TnSHmq
7343QFkgmHcM9bC2gKTb50d6OOyrjv4HFH7WyYu2MarQYHl9jcSOsn8LNX6xAPvo
Ok+EuHX7np+jp0DkvRsl
=19/1
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Nov_2013_09_27_09_+1100_C1jvd30POwUQPQGb--

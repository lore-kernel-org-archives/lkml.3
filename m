Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaGKWNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:13:30 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47324 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaGKWN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:13:29 -0400
Date: Fri, 11 Jul 2014 23:13:24 +0100
From: James Hunt <james.hunt@ubuntu.com>
To: upstart-devel@lists.ubuntu.com, linux-kernel@vger.kernel.org
Subject: Upstart 1.13 released
Message-ID: <20140711221324.GA22059@faire>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline


Summary of changes:

* Fix for handling upgrade from non-stateful-re-exec instance to a
  stateful-re-exec-capable one (LP:#1303891).
* Disable chroot sessions by default. A new '--chroot-sessions' command-line
  option restores the old default behaviour.
* New tests and improved documentation.
* Fix for Session Init umask change on re-exec (LP: #1302117).
* Allow '--confdir' to look for system jobs in multiple locations, which also
  adds new command-line options '--append-confdir' and '--prepend-confdir' for
  full flexibility (LP: #1315060).
* Allow initctl(8) commands 'set-env' and 'unset-env' to operate on multiple
  environment variables (LP: #1324096).
* Support for cgroups via a new 'cgroup' stanza. This makes use of cgmanager(8)
  and is available to both System and Session Inits.  Support for cgroups can be
  disabled at built-time if required. See init(5) for 'cgroup' stanza syntax?


Kind regards,

James.
--
James Hunt
____________________________________
#upstart on freenode
http://upstart.ubuntu.com/cookbook
https://lists.ubuntu.com/mailman/listinfo/upstart-devel

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTwGGEAAoJEJ1Q4UTmNXMnwLIP/2CbxHtUIHvDNYkQdRNcgWNz
Bk2haS2iQi2ttuNt8FpkWAlEno2EmUTsvY79XDfYOKVDGuLDGGDntflUcVGDqQ6N
HeePhfQoHvQ6EAvOEVrYdP6UukuhFYy8/b98hAY03233k/zqNQoMT8ZY3iA5Ofb8
p82WdRBWjLZhd19Eq5qgzRx/Fyw+7AZ7CjzT9xNRxsdCP/z1xevzy/WZWzPRUjXx
VxMTMoJqUytLI3bw75Lo41PQKgd4UeSIMILGo28jz5VPeKSZ1NpPicRXCB/MGsh/
z6UtjLrwT+JaUnmN4hmVCGn2MioBrxKznp2yX9lv8DjraFiouwMMgAqgOW8td9oM
/JJjrKOwM8CHbcQBsW4doJu6bT++hbkPqMxjFov+a7X4MQHkO65VLUl8kVwiwBx0
7iKmD8j1j1gpgacmnMlDCbgbGj838MzP2Mg4OLhXCOVZUHPZKp2kR6trbwe1s8gr
ird9OF2K03q0VF9/N2+CNZvQee5QiunX9isMvPj7ZxE2jMOS7v/TyOCXnKbMxQ+X
E/TUyNMvqTc4vUdiJHpvyLIBt/X4k6vIlNHLk5fYrHCWo2M7cYo4U39im24il94t
CqkplXZmBIxCzQ4fPr3B4Y5yRAwocrxQoOvp/t8FsTzUDRHreIrerAQBoH/oX3cH
G4IMIPP8m512poMUyWNA
=Ju25
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--

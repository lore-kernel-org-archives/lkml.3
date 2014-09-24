Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaIXFjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:39:09 -0400
Received: from ozlabs.org ([103.22.144.67]:46265 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbaIXFjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:39:06 -0400
Date: Wed, 24 Sep 2014 15:38:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: linux-next: manual merge of the tip tree with the audit tree
Message-ID: <20140924153857.191a97a4@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5RuMqHSjQxWmZ2iYe6Bek_J"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5RuMqHSjQxWmZ2iYe6Bek_J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/entry_64.S between commit b4f0d3755c5e ("audit: x86:
drop arch from __audit_syscall_entry() interface") from the audit tree
and commit 1dcf74f6edfc ("x86_64, entry: Use split-phase
syscall_trace_enter for 64-bit syscalls") from the tip tree.

I fixed it up (probably incorrectly - I removed the auditsys section
as that is what the latter did) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/5RuMqHSjQxWmZ2iYe6Bek_J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIlj3AAoJEMDTa8Ir7ZwVXrMQAJLqwRsUszFniIgdVsSDoK3r
lGyMt537l175TqijSpiebnJZKuylUgsFldn58phRW1N+YQ8gE7RlvOE42lJEOjJW
zV/vEMQCEfmDpZVMCq1VRtJt4xwVPN4I2TCzy/ET8GFVZh2Vfw637P+5hF4qtJZK
yLPfMPifjPFHXKC5uIFYTclG+3KYIIRuIUWPv7gVAGe7C/1oHao0IUEGFr6eQZ1e
wVXToHI697GZdd8mRunJSUPIxqImdBxzQxLFyacTHMr5s+cpyLrLVL49wWTjTzBN
rBNPYZ9kKwtm4XAs6c3J4wJ5x7HaRyk33VueU3XkhLZ+yMosHsMPXbVBMobeolbh
40K9iZFoAhxezwxvunbYqDfHglGqf/CrQ+b8w8bWAUAU3H47MtS1vBCIETgRW9fJ
+xFo0PJfS1nJYCMSH1TbdKAEsPxvufIdNPwTvHDc7ncUeCY/TChZyEfs2pWECYVZ
/1fEX97mcFnT/NhV7TQWwoYqTULB/z3tHCSqBlrWnH4nBeNdfxtO57mjKbC2l0sJ
9R1iI4xiL8prJY6WUIp8szaIRozRKu1f6ShW9/ZeCTAI9GPmPaJXkz+UQF9NiXwV
/JKhtIh29jV09GYZq8RLx48wli0jIt9nsXhboEjUbJj7L3y8+zsmm+yKMc0G1a/L
ErUIb2tMe3wCHPnV6zW4
=nlMt
-----END PGP SIGNATURE-----

--Sig_/5RuMqHSjQxWmZ2iYe6Bek_J--

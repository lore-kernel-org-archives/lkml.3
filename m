Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaI3OyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:54:01 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:44017 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaI3Ox7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:53:59 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
In-Reply-To: Your message of "Tue, 30 Sep 2014 10:48:54 -0400."
             <20140930144854.GA5098@wil.cx>
From: Valdis.Kletnieks@vt.edu
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com> <15705.1412070301@turing-police.cc.vt.edu>
            <20140930144854.GA5098@wil.cx>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1412088827_2231P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Sep 2014 10:53:47 -0400
Message-ID: <123795.1412088827@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1412088827_2231P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Sep 2014 10:48:54 -0400, Matthew Wilcox said:

> No, it doesn't try to do that.  Wouldn't you be better served with an
> LD_PRELOAD that forces O_DIRECT on?

Not when you don't want it on every file, and users are creating and
deleting files once in a while.  A chattr-like command is easier and
more scalable than rebuilding the LD_PRELOAD every time the list of
files gets changed....

--==_Exmh_1412088827_2231P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVCrD+wdmEQWDXROgAQLYxw/+KGYWwJ0+oHZ6w4rAsmBsZGNLmCjxPEQc
W4JimJCgapPxYR62Tk4njVsMAQtktGGxrnpg2uw3glO5093FJkc3DblQTT31ram4
B/Vx17WwkB2X+j2E4zng0tuERF0QPuGgTGp/zfEVcDcR1oUftI8VFUoejdllGPyi
wyboTr47oVpethWRPhc/25/y5J0f6aZUSxybMYo9qGygaMxGbjmDPt6l0QSyxSty
hcEsAYSsjOpiA6yDe/8frog93FrsTuJQtFq5tHk/PC39bRp7zFWQZIUQhH74kPUU
oT3MCN0qtKNA9ed36pRmNTVeInrRoGXrkANEFQYHdLL9v/ranNj1pb06TzBTQdvH
tXmEVfiTZH+ZG2RWDPmBbs1Zjt3ASuhSCeymxHNscgOuaDH3+jigUpj1cOYmmWgT
9IeR+2TlJVpA5jkT1akm5Y+gqIMK7WlnmanksnAoRUz/7rmJvFwYtfzpak5XX1Nb
YmbZvwfiZDWMGvpUl9YdH53sB+KG2TVDkKy6UP+pZtWCUyfhCpALMldAlXm1spTh
kfehsJZNO0BzYQGNJ9HBw75toK1zoBdPiULuzdq3AH50rVAY6Z8SxApwwemx5zld
P6T6ZUgZDqTNhedhuBZ1/1NxIBSx7JiJcu/rBA8y44TJBBfQRpevLHVgjUkNmSSH
5yU6Hwlbig0=
=oz0U
-----END PGP SIGNATURE-----

--==_Exmh_1412088827_2231P--

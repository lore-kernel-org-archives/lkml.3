Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaB0Kcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:32:48 -0500
Received: from [217.156.133.130] ([217.156.133.130]:56850 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750952AbaB0Kco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:32:44 -0500
X-Greylist: delayed 1154 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 05:32:43 EST
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Thu, 27 Feb 2014 10:13:17 +0000
Message-ID: <530F0FBB.1030101@imgtec.com>
Date: Thu, 27 Feb 2014 10:13:15 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: [GIT PULL] Metag arch and asm-generic fixes for v3.14
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="ulL7A0WDGj4ucC4uPPjucJB8w0ssLRNvK"
X-Originating-IP: [192.168.154.65]
X-ESG-ENCRYPT-TAG: e1bf74bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ulL7A0WDGj4ucC4uPPjucJB8w0ssLRNvK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the following changes since commit cfbf8d4857c26a8a307fb7cd25=
8074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

which are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-fixes-v3.14

for you to fetch changes up to f229006ec6beabf7b844653d92fa61f025fe3dcf:

  irq-metag*: stop set_affinity vectoring to offline cpus (2014-02-25 22:=
35:06 +0000)

Thanks
James

----------------------------------------------------------------
Metag arch and asm-generic fixes for v3.14

- Add the new sched_setattr/sched_getattr syscalls to the asm-generic
  syscall list, which is used by arc, arm64, c6x, hexagon, metag,
  openrisc, score, tile, and unicore32.

- An IRQ affinity bug fix for metag to prevent interrupts being vectored
  to offline CPUs when their affinity is changed via /proc/irq/ (thanks
  tglx).

----------------------------------------------------------------
James Hogan (2):
      asm-generic: add sched_setattr/sched_getattr syscalls
      irq-metag*: stop set_affinity vectoring to offline cpus

 drivers/irqchip/irq-metag-ext.c   | 2 +-
 drivers/irqchip/irq-metag.c       | 2 +-
 include/uapi/asm-generic/unistd.h | 6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)


--ulL7A0WDGj4ucC4uPPjucJB8w0ssLRNvK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTDw+8AAoJEKHZs+irPybf9AEP/3I6KgEk9G0XMqzxKml6sF6W
XFy/2em41sttC4ZKqrQzrd0zxwi/QAG5pxlZ30D0Y4iWLC1RgWUxs19mkuPzJb4q
l8nP6/f3L+fhYTNe1EyuLhPC0CiuisuSmRMel6k5YRJsaHT46Kf2GkwIImb4pCka
X9GrF6ZB1iYge8FfzCeNCr5fL7dyCC4LKNsZ78OiHnhktQreKSOswYWWkzhngEa0
xTjlzIT605RQjtssAWj98wXGSo9Kk++5xyvUe5t/FOImI/pQFIU3VKkEfS+fCf6d
1z/z88gXanape1pF3WFYCZPL58RHYDcizNkvbb1aFwNI4rdjyjsxde4j/+x8NkuM
OJ6luU+r4GkMivVe9svNdYIzeiAKNZE/t0gueb/K/vpLY6rVrSuVa7MoUB8FvYSE
OMj5B6kp48XG+ocRvqRcYyHAfeUGdLcI8GmFlIGn9lbhRSGb13e4fu5zIW/GacZW
/ST9hyM20dshNS9FTL5eszsHQa6wpm3ORSTB752PUgZphc9+ExxLavAAj8Es2how
W7HFohxvuibjbO9/G2Jck/aSADAcr45oAarOGjmY0YA4dL7zjSKQTqKsRg5jKgPX
4In1Ud0YMv87fWUQ2xHovOmy5GRTKmMPHn29erTXVKWDOB/GUnS8L/4gfdfbsqVB
BX+Xc4U2J6dIrs/RJK2D
=fH3w
-----END PGP SIGNATURE-----

--ulL7A0WDGj4ucC4uPPjucJB8w0ssLRNvK--

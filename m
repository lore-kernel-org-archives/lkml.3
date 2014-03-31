Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaCaCks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:40:48 -0400
Received: from ozlabs.org ([203.10.76.45]:47726 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbaCaCkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:40:46 -0400
Date: Mon, 31 Mar 2014 13:40:51 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3.2 153/200] powerpc/le: Ensure that the 'stop-self' RTAS
 token is handled correctly
Message-ID: <20140331024050.GA8915@thor.bakeyournoodle.com>
Mail-Followup-To: Ben Hutchings <ben@decadent.org.uk>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	akpm@linux-foundation.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <lsq.1396221814.369444335@decadent.org.uk>
 <lsq.1396221815.799153951@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <lsq.1396221815.799153951@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2014 at 12:23:35AM +0100, Ben Hutchings wrote:
> 3.2.56-rc1 review patch.  If anyone has any objections, please let me kno=
w.

This patch doesn't need to go back beyond 3.10, so it's safe to drop
=66rom your queue.

Thanks Ben.

Yours Tony

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJTONWyAAoJEPvNNsFAAoTBvSYQALugL/x1sLaBRAyVe6e+SAKJ
u8QotElKyOlggJGe0wBtUwIC0pQGydffsioUI8/OMrEMy4ZV01VBTsBHJuHqtTxB
+Khn0HQKgjZCLmCwimtdbF9SIZPMAzQsYZo1FUEZiEcx4PzUelH+e39qscOsVCAX
w+jCHIgBLvXU5LW1UFZs0ECSgl+ZJiJNMwpDtTz9odS522xY20DBq61buOeDIrT7
kz5tR9fAA1WLpqpZYnQCEB6Fq8hJyhhmm0AkwIf9K1HYqgAMaXjEYunRCyQ+qMuA
FyNV0zfME0ep3dTai1BScWSTHNX0tPe8cioGWfWmWLNDT6YG66/yWDjMSD0beI0P
Z7/TznUWBEt3fu0Wx8EkBHys96rQzHspCokaHBm54GbFEkGdTMVbsKVnik7LR4ha
iVmzEXB7G3VQ3B69qCX8Uo6RosLLS5gu36nEuxRvSkkAVvFmsQYqpOtnGPydZQmw
RqCoW79fepTKWNGSENlSBywnR255WkyWknkiPhL5mshL3JPaENqoypJKLHSToYqQ
cFRxaNXWwkI4WXH/YZzpCCwIG1R78iokceYClI7OFdwqQgfnzy07lZsKM8AcZ43e
s4newPhv/DwfhTo7RumCDI1QiQgfkhImCu4Qe1j4JLFDvsKaZ53SjZxHxubNhjEG
AlLDhnd0U+GOxsYjumol
=dROI
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--

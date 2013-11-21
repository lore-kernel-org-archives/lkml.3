Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3KUUot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:44:49 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:57266 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab3KUUop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:44:45 -0500
X-Spam-Flag: NO
Message-ID: <528E70B5.5010603@pavlinux.ru>
Date: Fri, 22 Nov 2013 00:44:37 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2.52-rt73
References: <20131116194633.GD11518@linutronix.de>
In-Reply-To: <20131116194633.GD11518@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="GaQnvvUubM9dwd0RACl7iJW3wDmPm7U4r"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GaQnvvUubM9dwd0RACl7iJW3wDmPm7U4r
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Fine, killed 3.12 now decided to finish 3.2.x. Good job guys!

Not configuration, not hardware, not software has not been updated or cha=
nged.

BUG: scheduling while atomic: irq/74-sata_nv/57/0x00000002
Modules linked in: cls_u32 sch_sfq sch_htb
Pid: 57, comm: irq/74-sata_nv Tainted: G           O 3.2.52-rt73 #10
Call Trace:
 [<ffffffff814bdef4>] ? __schedule+0x314/0x344
 [<ffffffff81081b77>] ? task_blocks_on_rt_mutex+0x1e7/0x280
 [<ffffffff814be741>] ? schedule+0x21/0xa0
 [<ffffffff814c0d88>] ? rt_spin_lock_slowlock+0x128/0x280
 [<ffffffff81204d01>] ? blk_update_request+0x11/0x450
 [<ffffffff812a6976>] ? add_timer_randomness+0x86/0x1e0
 [<ffffffff81206eac>] ? blk_end_request+0x9c/0xc0
 [<ffffffff812c629a>] ? scsi_io_completion+0x9a/0x770
 [<ffffffff8120d4ab>] ? blk_done_softirq+0x6b/0x80
 [<ffffffff8104a805>] ? __do_softirq_common+0xa5/0x1d0
 [<ffffffff81094ec0>] ? irq_thread_fn+0x50/0x50
 [<ffffffff8104ad77>] ? local_bh_enable+0x127/0x150
 [<ffffffff81094f08>] ? irq_forced_thread_fn+0x48/0x70
 [<ffffffff81094d80>] ? irq_thread+0x150/0x240
 [<ffffffff81094c30>] ? disable_irq_nosync+0x60/0x60
 [<ffffffff81067150>] ? kthread+0x80/0x90
 [<ffffffff814c3174>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810670d0>] ? kthread_bind+0x80/0x80
 [<ffffffff814c3170>] ? gs_change+0xb/0xb


BUG: scheduling while atomic: ksoftirqd/3/27/0x00000002
Pid: 3, comm: ksoftirqd/0 Tainted: G           O 3.2.52-rt73 #10
=2E..
BUG: scheduling while atomic: ksoftirqd/0/3/0x00000002
Pid: 27, comm: ksoftirqd/3 Tainted: G           O 3.2.52-rt73 #10
=2E...
BUG: scheduling while atomic: ksoftirqd/0/3/0x00000002
Pid: 27, comm: ksoftirqd/3 Tainted: G           O 3.2.52-rt73 #10



--=20

                                                         Pavel.




--GaQnvvUubM9dwd0RACl7iJW3wDmPm7U4r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJSjnC2AAoJEPtok08Dny2hUmMP/jn+54ifyiHlijInPspgF/75
eAd8IHi33BF5RwhHagUR2bUSZ7O5cI9Z350mVetbijbuoFtXsMlZpayvIY/PIy9V
x0GYlmvwbL1Sh+9Jo0Rgij6ePDQDwptXFfz/re+oE2qFddcnUQURfiEEEHO6JP1B
VV52xA8wXVnhg01QKB1m8GXiCgJfzvdhVxL4G47ezwu8R80Vr1A950F/5pPbFoHt
TnBCUKdV3qImHyc0EzMUAWz4UAjS4pd42XYVV2Qjyp9Ja4Rkcq5LZi5DAouGFRxz
qBR0J85jhRdWP9LV2Of7/qUoLPGHHs0LWWrboNUXvfcneN3I1Q4u0nSa1rrNhrJV
Qm/94NllM2asA9eGMGMa6Lk3kMkah1fXFbtEdYQshVE7Oc1zZ2XMcqKgX9U/tS6L
k51pn5uQz0EGA2I7G/4VS7EAXyhsezKYLuj3q29mA5/rY6uJGjUB038j9NmM0hoK
OuMrG6iuV1h0n3Ik0RT+aaKm9zex70UyFDtf64uG8ts+2dUa0G47m8NVIAmbDmxA
aENUgZ0kBFGzqYE37YsV21Z7BlJ5mqcCSaSr4vqCjoWLJoBf2rMEeNiHaVxkAEPZ
9Hn9BYixctug+n9cXsfnhfgrbYedWPXH7Q+V7fFdolVvoigBTWHFAIOzM6YlnUJF
Z/zu9vLOELuhWK6Mz3m1
=9eAD
-----END PGP SIGNATURE-----

--GaQnvvUubM9dwd0RACl7iJW3wDmPm7U4r--

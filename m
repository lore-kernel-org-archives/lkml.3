Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LLUaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:30:08 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:37109 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3LLUaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:30:04 -0500
X-Spam-Flag: NO
Message-ID: <52AA1CC0.30307@pavlinux.ru>
Date: Fri, 13 Dec 2013 00:29:52 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: Pavel Vasilyev <pavel@pavlinux.ru>
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
CC: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 3.12.5 CRASH/FREEZE
References: <52A9CC77.20904@linaro.org>
In-Reply-To: <52A9CC77.20904@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="a4t9wMUtV99ueqbgh1gTeDWwwfERmhmPo"
X-DCC-STREAM-Metrics: ss27-so02.mtu.ru 10001; Body=2 Fuz1=2
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a4t9wMUtV99ueqbgh1gTeDWwwfERmhmPo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On startup, if USB webcam (uvcvideo) attached in usb-hole


NMI backtrace for cpu 1
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.5-plx #6
Hardware name: PEGATRON CORPORATION SAISHIAT2/IPPCR-SS, BIOS 0308 10/31/2=
012
task: f60a4420 ti: f60b4000 task.ti: f60b4000
EIP: 0060:[<c13f3be5>] EFLAGS: 00200246 CPU: 1
EIP is at poll_idle+0x95/0xb0
EAX: 00000000 EBX: f67d13d8 ECX: 00000019 EDX: f60b4000
ESI: af9fbf64 EDI: 000000a7 EBP: f60b5f54 ESP: f60b5f44
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 80050033 CR2: b7ec2000 CR3: 35768000 CR4: 000407b0
Stack:
 00000000 c1648af0 f67d13d8 c1648ae0 f60b5f78 c13f3ddf af9fbbd8 000000a7
 00000000 00000000 c1679f24 c1678a00 f67cedc0 f60b5f80 c100ba68 f60b5f8c
 c1084272 00000001 f60b5fb4 c1025018 02100800 00000000 00000000 360b5fb4
Call Trace:
 [<c13f3ddf>] cpuidle_idle_call+0x9f/0x1c0
 [<c100ba68>] arch_cpu_idle+0x8/0x20
 [<c1084272>] cpu_startup_entry+0xe2/0x110
 [<c1025018>] start_secondary+0x1a8/0x210
Code: 8d b6 00 00 00 00 3d ff ff ff 7f 77 e0 89 43 08 8b 45 f0 83 c4 04 5=
b 5e 5f
5d c3 8d 76 00 89 e2 81 e2 00 e0 ff ff f3 90 8b 42 08 <a8> 08 75 97 8b 42=
 08 f6
c4 02 75 8f eb ed 8d b6 00 00 00 00 8d
NMI backtrace for cpu 0
CPU: 0 PID: 35 Comm: irq/43-xhci_hcd Not tainted 3.12.5-plx #6
Hardware name: PEGATRON CORPORATION SAISHIAT2/IPPCR-SS, BIOS 0308 10/31/2=
012
task: f58f8da0 ti: f5900000 task.ti: f5900000
EIP: 0060:[<c1027c38>] EFLAGS: 00000046 CPU: 0
EIP is at default_send_IPI_mask_logical+0x78/0xa0
EAX: 00000c00 EBX: 03000000 ECX: c163d200 EDX: fffff000
ESI: 00000c00 EDI: 00000006 EBP: f5901ba8 ESP: f5901b94
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 80050033 CR2: b7ec2417 CR3: 35166000 CR4: 000407b0
Stack:
 00000006 00000002 00002710 000026c8 c1641140 f5901bb8 c1027d70 00002710
 000026c8 f5901bc8 c1027f31 c15d69cd f67c1c60 f5901c14 c10a987b c1603e90
 000927c9 0000026b 0000026a 000026c8 aea0554e f5901bf0 00000000 f5901c14
Call Trace:
 [<c1027d70>] default_send_IPI_all+0x80/0x90
 [<c1027f31>] arch_trigger_all_cpu_backtrace+0x41/0x70
 [<c10a987b>] rcu_check_callbacks+0x2db/0x650
 [<c106491d>] ? scheduler_tick+0xad/0x120
 [<c1044f15>] update_process_times+0x45/0x60
 [<c109282a>] tick_handle_periodic+0x3a/0x1f0
 [<c10264d4>] smp_apic_timer_interrupt+0x54/0x90
 [<c1508042>] apic_timer_interrupt+0x2a/0x30
 [<c13a55b2>] ? inc_enq+0x12/0x170
 [<c13aa59c>] xhci_queue_isoc_tx_prepare+0x39c/0x950
 [<c10264d9>] ? smp_apic_timer_interrupt+0x59/0x90
 [<c139d35f>] xhci_urb_enqueue+0x22f/0x540
 [<c1375745>] usb_hcd_submit_urb+0x65/0x280
 [<c13e3029>] ? uvc_video_decode_isoc+0x149/0x220
 [<c13777a0>] usb_submit_urb+0x170/0x3a0
 [<c103cd06>] ? irq_exit+0x56/0x70
 [<c13e1ee8>] uvc_video_complete+0xb8/0xd0
 [<c1374625>] __usb_hcd_giveback_urb+0x45/0xa0
 [<c1374bd8>] usb_hcd_giveback_urb+0x38/0xf0
 [<c13a84cf>] handle_tx_event+0x3af/0xda0
 [<c103cd06>] ? irq_exit+0x56/0x70
 [<c10264d9>] ? smp_apic_timer_interrupt+0x59/0x90
 [<c15088a9>] ? common_interrupt+0x29/0x2e
 [<c13a9082>] xhci_irq+0x1a2/0x6c0
 [<c1508042>] ? apic_timer_interrupt+0x2a/0x30
 [<c13a95aa>] xhci_msi_irq+0xa/0x10
 [<c1084c31>] irq_forced_thread_fn+0x21/0x70
 [<c1085046>] irq_thread+0x106/0x220
 [<c1084c10>] ? irq_finalize_oneshot.part.40+0xc0/0xc0
 [<c1084cc0>] ? irq_thread_fn+0x40/0x40
 [<c1057110>] kthread+0xd0/0xe0
 [<c1084f40>] ? set_affinity_thread+0x140/0x140
 [<c15083b7>] ret_from_kernel_thread+0x1b/0x28
 [<c1057040>] ? kthread_flush_work_fn+0x10/0x10
Code: 80 e5 10 75 ee c1 e3 18 89 98 10 c3 ff ff 89 d0 09 f0 81 ce 00 04 0=
0 00 83
fa 02 8b 15 44 d5 63 c1 0f 44 c6 89 82 00 c3 ff ff 57 <9d> 8b 5d f4 8b 75=
 f8 8b
7d fc 89 ec 5d c3 89 55 f0 ff 90 b4 00
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long =
to run:
71.797 msecs

---

3.2.53 - works fine :)



--a4t9wMUtV99ueqbgh1gTeDWwwfERmhmPo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJSqhzBAAoJEPtok08Dny2hNtAQAIteyQqphhj1648ON1PE0njS
mjBH1yZ8Tt3pDYOPy8WIJ8or6koq4o1hBRaw6MT3d2Jbb8i0OtDhFi5WivKgFV8Q
fyXVEbmElyHzZAL1i/mr08MVRRUTQJ5ZsNjByuxqLxWKDBQ4Te80KB3piGGD4WMr
T35zQxaMaRSyPVRgDm9lusFX6y2s4aIoArEnCccBjJBnjnIfK570XTff7MVWuDoy
NI5AVJkin2uYwGymuK/nXS31UnN0Ukx1eKD9KevZrGUn9rUOaltmUhS9DoRXUFF2
v1IOeYSvoj0YY+3bftB4Vn2KKfdo2eqfQzK1zWVjdkRMjd/JDVaNhnXBZWPlI0my
qwHsqxW8Lxh72dgfP/A9i6ekFtbarAunTdkEaiZGT0/V+B3FvXG41NlCfTNNg4vv
i4qMK/l8V+u7CPtXbVpsACFki3d166AJDC0JHPoddKGM5OJ3uVfmFRzimNqBzzmN
qPOqNznx48Yr7wzbPJjbe9FKe2yLkjF74fTchc/8Vaq2gIphiDnpHuve+x0PsmTx
B3+npImjsWLIqM3dOwgmWx4zbyhKpGoM3OiQzaPxbI4shijIDpnSfYdYNMeW61Mh
hbBPo6nr7mtxVCKAz9Vfq/ikheECNf4SUpQFHCo0ZWMCD6s/ugQ5lXzShs1Pw9Is
0RP+6nwRMgZCYrde7N69
=iPc+
-----END PGP SIGNATURE-----

--a4t9wMUtV99ueqbgh1gTeDWwwfERmhmPo--

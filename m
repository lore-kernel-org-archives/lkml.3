Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaAVQXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:23:41 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:55259 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaAVQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:23:38 -0500
MIME-Version: 1.0
Date: Wed, 22 Jan 2014 08:23:36 -0800
Message-ID: <CACUGKYPXficVuqDgy6_Tnh9b-VOXDNK=+nqb6U5O6NpcZOGGpQ@mail.gmail.com>
Subject: Internal error: Oops: 17 [#1] ARM
From: John Tobias <john.tobias.ph@gmail.com>
To: "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am using 3.13-rc1 kernel on iMX6SL processor. My filesystem is in
eMMC running SDR50.
Is anyone here encountered these problem and if there's any existing
patch that I can get?.

Regards,

john

[ 1552.394899] Unable to handle kernel NULL pointer dereference at
virtual address 00000037
[ 1552.403034] pgd = beef4000
[ 1552.405855] [00000037] *pgd=bef60831, *pte=00000000, *ppte=00000000
[ 1552.412245] Internal error: Oops: 17 [#1] ARM
[ 1552.416627] Modules linked in: bt8xxx(O) sd8xxx(O) mlan(O)
[ 1552.422249] CPU: 0 PID: 232 Comm: commsd Tainted: G           O 3.13.0-rc1 #7
[ 1552.429409] task: bfbc7500 ti: bec96000 task.ti: bec96000
[ 1552.434844] PC is at lookup_fast+0x5c/0x318
[ 1552.439067] LR is at mark_held_locks+0x78/0x13c
[ 1552.443622] pc : [<80101184>]    lr : [<80056e48>]    psr: a00f0013
[ 1552.443622] sp : bec97d88  ip : 00666e6f  fp : bec97ddc
[ 1552.455124] r10: 00000000  r9 : bec97e08  r8 : 80102d94
[ 1552.460370] r7 : bec97e60  r6 : bf133ac8  r5 : bec97e60  r4 : bec97e00
[ 1552.466918] r3 : bee4f01d  r2 : 00000000  r1 : ffffffff  r0 : ffffffff
[ 1552.473471] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[ 1552.480629] Control: 10c53c7d  Table: beef4059  DAC: 00000015
[ 1552.486397] Process commsd (pid: 232, stack limit = 0xbec96238)
[ 1552.492341] Stack: (0xbec97d88 to 0xbec98000)
[ 1552.496728] 7d80:                   80102b94 80057108 bfb95310
bf133ac8 bf15f4e8 bfb95310
[ 1552.504936] 7da0: c08bb14d ffffffff bee4f015 00000008 bfbc7500
bec97e08 00000000 00000041
[ 1552.513142] 7dc0: bec97e60 bec96020 bec96000 00000000 bec97e3c
bec97de0 80102d94 80101134
[ 1552.521347] 7de0: bec97df8 00000000 800d982c bec96018 00000010
bec97e00 00000000 bec97e08
[ 1552.529553] 7e00: 8026e25c 800d97e8 bee4f000 00000ff0 80d4e3a4
00000001 bee4f000 bec97e60
[ 1552.537758] 7e20: ffffff9c ffffff9c bec96000 00000000 bec97e5c
bec97e40 801033bc 80102c70
[ 1552.545964] 7e40: bee4f000 00000001 bec97e60 bec97f00 bec97ee4
bec97e60 80105dc0 80103398
[ 1552.554170] 7e60: bfb95310 bf133ac8 c08bb14d 0000000b bee4f015
8005992c bfb95310 bf133398
[ 1552.562375] 7e80: bf15f4e8 00000041 00000002 0000008a 00000000
00000000 600f0013 bec96000
[ 1552.570581] 7ea0: ffffffea bf8c1840 807b4430 80115444 801156e4
8011563c 00000008 00000000
[ 1552.578786] 7ec0: bec97f04 733fe4e0 00000001 ffffff9c 757e3810
bec97f40 bec97efc bec97ee8
[ 1552.586991] 7ee0: 80105e0c 80105d68 00000000 bc950fe0 bec97f2c
bec97f00 800faf64 80105df4
[ 1552.595196] 7f00: 801156e4 80115420 bec97f54 733fe4e0 733ff8f0
733fe61c 000000c3 8000f504
[ 1552.603402] 7f20: bec97f3c bec97f30 800fafe0 800faf1c bec97fa4
bec97f40 800fb71c 800fafc4
[ 1552.611608] 7f40: 8000f310 bfbc7500 733fe550 8000f458 733fe61c
000000c3 bec97f84 bec97f68
[ 1552.619813] 7f60: 80056f28 800a0270 733fe550 733ff8f0 733fe61c
000000c3 bec97f94 bec97f88
[ 1552.628019] 7f80: 80057110 80056f18 00000000 bec97f98 8000f458
733fe550 00000000 bec97fa8
[ 1552.636226] 7fa0: 8000f280 800fb704 733fe550 733ff8f0 757e3810
733fe4e0 733fe550 00000003
[ 1552.644431] 7fc0: 733fe550 733ff8f0 733fe61c 000000c3 00000000
00000002 733fe92c 00000200
[ 1552.652636] 7fe0: 000000c3 733fe4d8 7579b7e5 7572e276 200f0030
757e3810 bfffd821 bfffdc21
[ 1552.660828] Backtrace:
[ 1552.663343] [<80101128>] (lookup_fast+0x0/0x318) from [<80102d94>]
(path_lookupat+0x130/0x728)
[ 1552.671994] [<80102c64>] (path_lookupat+0x0/0x728) from
[<801033bc>] (filename_lookup.isra.40+0x30/0x70)
[ 1552.681515] [<8010338c>] (filename_lookup.isra.40+0x0/0x70) from
[<80105dc0>] (user_path_at_empty+0x64/0x8c)
[ 1552.691361]  r7:bec97f00 r6:bec97e60 r5:00000001 r4:bee4f000
[ 1552.697163] [<80105d5c>] (user_path_at_empty+0x0/0x8c) from
[<80105e0c>] (user_path_at+0x24/0x2c)
[ 1552.706053]  r8:bec97f40 r7:757e3810 r6:ffffff9c r5:00000001 r4:733fe4e0
[ 1552.712927] [<80105de8>] (user_path_at+0x0/0x2c) from [<800faf64>]
(vfs_fstatat+0x54/0xa8)
[ 1552.721232] [<800faf10>] (vfs_fstatat+0x0/0xa8) from [<800fafe0>]
(vfs_stat+0x28/0x2c)
[ 1552.729167]  r8:8000f504 r7:000000c3 r6:733fe61c r5:733ff8f0 r4:733fe4e0
[ 1552.736031] [<800fafb8>] (vfs_stat+0x0/0x2c) from [<800fb71c>]
(SyS_stat64+0x24/0x40)
[ 1552.743902] [<800fb6f8>] (SyS_stat64+0x0/0x40) from [<8000f280>]
(ret_fast_syscall+0x0/0x48)
[ 1552.752359]  r4:733fe550
[ 1552.754946] Code: eb00352d e3500000 e50b0038 0a000080 (e5903038)
[ 1552.761270] ---[ end trace 02679086a39365e8 ]---
[ 1552.765968] Kernel panic - not syncing: Fatal exception

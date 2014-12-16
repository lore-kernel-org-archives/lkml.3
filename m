Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaLPCY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:24:28 -0500
Received: from nm7-vm1.access.bullet.mail.bf1.yahoo.com ([216.109.114.160]:33394
	"EHLO nm7-vm1.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbaLPCYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:24:23 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2014 21:24:22 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=rogers.com;
	b=qBmEH5wSZjs+lLOTvib9CuSxrgIhBJHjegcZpPBVbcR8UP3rixO0kDILXtH4d9uLVGTw7WwsCE6vic4tGZl27lMg0i3j/mZqOuBdCOXsWR8uYRBOD0pxKWYKIWou57lnqPpJFi63acXiD5pY5vpf31HY9susaVK+FjLE68j2f7fwghSlvJp9zdHw2Rx/gA2WaFlCLtWNYTZfa7WAcRSv1Wqp8hyuoNZcteJFcC1AcGZwYRrjtjI2U0ZqWpkdYLBnvxS37jkirUigcXUJ+WKxfyIo8BaytcwIqPxOHd8xspFFjd70129bsam/uVhrArnOAvGOsQUQoi7vAuiT1I0+HA==;
X-Yahoo-Newman-Id: 538478.73161.bm@smtp111.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZUVO07oVM1mg.nhU3uLVgQ15xCIhUERiDa2Y6WB6DlyQdtQ
 JNtHEj8RKFfNiUtK7iCQ3MC6YZxM1M6B174ZiQ93mzGC8SBnKV4cJcshK5BY
 2m_5ueT.eiPqaCx6_pVAoIjwp7pCR4TrORIhoN248jP4eb5fyV_WGj7Kl_kV
 gwCzEk7UubCBhkNY.SNf3u4l9rQeSHTlokTlZPWh96D.kk2L1l94qtm_X2tc
 FAtXOM.XCj9IYLQ4PQ59fz7Sv76ogcasSs6pdN9p293myYJgWednbntAhlcJ
 g3m4To7XLBgnDIoZlOoIiaLeDNa.791sEMZIe8SagYEii_DxaQ3G2e6RSfjE
 auxnueilXSBQyzaHDYL5AGNnKw0y.lurawNRXA2Or2axj.6N10AeRNHe07Ni
 HUPgwjKfkFN1Z_PueuYymrtsrNPtiR_oJTYekpqWszGK57ZUExH8zF6K8Bmb
 4YarrwY5iiDDGD3kzDiTFE20RhsXOsTxwr0qpvqwjYZBxOoa63FnIWS2mp3U
 NSdoisK9YpZs8ehubmSyluymcYeRQlHtdwf5MUXE-
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [3.18][ACPI] and [drm] Dell Precision M6800 - bad ACPI sleep states / bogus BAR alignment
Date: Mon, 15 Dec 2014 21:17:47 -0500
Message-ID: <2679575.Rdirvozgzf@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.14.3 (Linux/3.18.0+; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel devs,

In my continuing use of this new laptop (Day 2), I'm encountering some other issues. I am using Dell's latest A11 BIOS that came out last month. I have switchable graphics currently turned on in the BIOS. Might be some bugs with this being active and other variables.

Will test any patches you might have for me.

Thanks,
Shawn

Below is full kernel message

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0+ (root@segfault.sh0n.net) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #1 SMP Sat Dec 13 21:38:30 EST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0+ root=UUID=4ca78ce8-7850-4f5e-9fab-3d675e5864af ro rhgb slub_debug=- cgroup_disable=memory console=tty0 console=ttyS0,115200n8 radeon.dpm=1 intel_iommu=on vfio_iommu_type1.allow_unsafe_interrupts=1 zswap.zpool=zsmalloc zswap.enabled=1 zram=1
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000004efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000004f000-0x000000000004ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000050000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bffc5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bffc6000-0x00000000bffccfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bffcd000-0x00000000c0991fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0992000-0x00000000c0e67fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c0e68000-0x00000000c7db2fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c7db3000-0x00000000c7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c8000000-0x00000000c8758fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c8759000-0x00000000c87fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c8800000-0x00000000c8f92fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c8f93000-0x00000000c8ffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000c9000000-0x00000000ca6d3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ca6d4000-0x00000000ca7fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ca800000-0x00000000cbcddfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cbcde000-0x00000000cbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cd000000-0x00000000cf1fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000082edfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xc558e018-0xc55aa657] usable ==> usable
[    0.000000] e820: update [mem 0xc557d018-0xc558d057] usable ==> usable
[    0.000000] e820: update [mem 0xc556d018-0xc557cc57] usable ==> usable
[    0.000000] e820: update [mem 0xc554f018-0xc556cc57] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000004efff] usable
[    0.000000] reserve setup_data: [mem 0x000000000004f000-0x000000000004ffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000050000-0x000000000009efff] usable
[    0.000000] reserve setup_data: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000bffc5fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000bffc6000-0x00000000bffccfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000bffcd000-0x00000000c0991fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000c0992000-0x00000000c0e67fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000c0e68000-0x00000000c554f017] usable
[    0.000000] reserve setup_data: [mem 0x00000000c554f018-0x00000000c556cc57] usable
[    0.000000] reserve setup_data: [mem 0x00000000c556cc58-0x00000000c556d017] usable
[    0.000000] reserve setup_data: [mem 0x00000000c556d018-0x00000000c557cc57] usable
[    0.000000] reserve setup_data: [mem 0x00000000c557cc58-0x00000000c557d017] usable
[    0.000000] reserve setup_data: [mem 0x00000000c557d018-0x00000000c558d057] usable
[    0.000000] reserve setup_data: [mem 0x00000000c558d058-0x00000000c558e017] usable
[    0.000000] reserve setup_data: [mem 0x00000000c558e018-0x00000000c55aa657] usable
[    0.000000] reserve setup_data: [mem 0x00000000c55aa658-0x00000000c7db2fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000c7db3000-0x00000000c7ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000c8000000-0x00000000c8758fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000c8759000-0x00000000c87fffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000c8800000-0x00000000c8f92fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000c8f93000-0x00000000c8ffffff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000c9000000-0x00000000ca6d3fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000ca6d4000-0x00000000ca7fffff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000ca800000-0x00000000cbcddfff] usable
[    0.000000] reserve setup_data: [mem 0x00000000cbcde000-0x00000000cbffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000cd000000-0x00000000cf1fffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000082edfffff] usable
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0xc8fd2000  ACPI=0xc8fd2000  SMBIOS=0xf04c0  MPS=0xfd710 
[    0.000000] efi: mem00: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000008000-0x0000000000009000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000009000-0x000000000003d000) (0MB)
[    0.000000] efi: mem03: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000003d000-0x000000000004f000) (0MB)
[    0.000000] efi: mem04: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000004f000-0x0000000000050000) (0MB)
[    0.000000] efi: mem05: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000050000-0x000000000009f000) (0MB)
[    0.000000] efi: mem06: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem08: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000001000000-0x00000000022d2000) (18MB)
[    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000022d2000-0x000000003d959000) (950MB)
[    0.000000] efi: mem10: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000003d959000-0x0000000040000000) (38MB)
[    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000040000000-0x000000008bd98000) (1213MB)
[    0.000000] efi: mem12: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000008bd98000-0x00000000bce8a000) (784MB)
[    0.000000] efi: mem13: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bce8a000-0x00000000bcf8a000) (1MB)
[    0.000000] efi: mem14: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bcf8a000-0x00000000be067000) (16MB)
[    0.000000] efi: mem15: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be067000-0x00000000be24e000) (1MB)
[    0.000000] efi: mem16: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be24e000-0x00000000be272000) (0MB)
[    0.000000] efi: mem17: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be272000-0x00000000be2b2000) (0MB)
[    0.000000] efi: mem18: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be2b2000-0x00000000be2bf000) (0MB)
[    0.000000] efi: mem19: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be2bf000-0x00000000be342000) (0MB)
[    0.000000] efi: mem20: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be342000-0x00000000be34f000) (0MB)
[    0.000000] efi: mem21: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be34f000-0x00000000be370000) (0MB)
[    0.000000] efi: mem22: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be370000-0x00000000be93e000) (5MB)
[    0.000000] efi: mem23: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000be93e000-0x00000000bea64000) (1MB)
[    0.000000] efi: mem24: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bea64000-0x00000000bea8e000) (0MB)
[    0.000000] efi: mem25: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bea8e000-0x00000000beaf2000) (0MB)
[    0.000000] efi: mem26: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000beaf2000-0x00000000beaff000) (0MB)
[    0.000000] efi: mem27: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000beaff000-0x00000000bf19b000) (6MB)
[    0.000000] efi: mem28: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf19b000-0x00000000bf1a9000) (0MB)
[    0.000000] efi: mem29: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf1a9000-0x00000000bf20b000) (0MB)
[    0.000000] efi: mem30: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf20b000-0x00000000bf218000) (0MB)
[    0.000000] efi: mem31: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf218000-0x00000000bf29b000) (0MB)
[    0.000000] efi: mem32: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf29b000-0x00000000bf2a8000) (0MB)
[    0.000000] efi: mem33: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf2a8000-0x00000000bf32b000) (0MB)
[    0.000000] efi: mem34: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf32b000-0x00000000bf338000) (0MB)
[    0.000000] efi: mem35: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf338000-0x00000000bf3bb000) (0MB)
[    0.000000] efi: mem36: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf3bb000-0x00000000bf3c8000) (0MB)
[    0.000000] efi: mem37: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf3c8000-0x00000000bf44b000) (0MB)
[    0.000000] efi: mem38: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf44b000-0x00000000bf458000) (0MB)
[    0.000000] efi: mem39: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf458000-0x00000000bf4db000) (0MB)
[    0.000000] efi: mem40: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf4db000-0x00000000bf4e8000) (0MB)
[    0.000000] efi: mem41: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf4e8000-0x00000000bf56b000) (0MB)
[    0.000000] efi: mem42: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf56b000-0x00000000bf578000) (0MB)
[    0.000000] efi: mem43: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf578000-0x00000000bf5fb000) (0MB)
[    0.000000] efi: mem44: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf5fb000-0x00000000bf608000) (0MB)
[    0.000000] efi: mem45: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf608000-0x00000000bf68b000) (0MB)
[    0.000000] efi: mem46: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf68b000-0x00000000bf698000) (0MB)
[    0.000000] efi: mem47: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf698000-0x00000000bf71b000) (0MB)
[    0.000000] efi: mem48: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf71b000-0x00000000bf728000) (0MB)
[    0.000000] efi: mem49: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf728000-0x00000000bf7ab000) (0MB)
[    0.000000] efi: mem50: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf7ab000-0x00000000bf7b8000) (0MB)
[    0.000000] efi: mem51: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf7b8000-0x00000000bf83b000) (0MB)
[    0.000000] efi: mem52: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf83b000-0x00000000bf848000) (0MB)
[    0.000000] efi: mem53: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf848000-0x00000000bf8cb000) (0MB)
[    0.000000] efi: mem54: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf8cb000-0x00000000bf8d8000) (0MB)
[    0.000000] efi: mem55: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf8d8000-0x00000000bf95b000) (0MB)
[    0.000000] efi: mem56: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf95b000-0x00000000bf968000) (0MB)
[    0.000000] efi: mem57: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf968000-0x00000000bf9eb000) (0MB)
[    0.000000] efi: mem58: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf9eb000-0x00000000bf9f8000) (0MB)
[    0.000000] efi: mem59: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bf9f8000-0x00000000bfa7b000) (0MB)
[    0.000000] efi: mem60: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bfa7b000-0x00000000bfa88000) (0MB)
[    0.000000] efi: mem61: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bfa88000-0x00000000bfb0b000) (0MB)
[    0.000000] efi: mem62: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bfb0b000-0x00000000bfb18000) (0MB)
[    0.000000] efi: mem63: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bfb18000-0x00000000bfb9b000) (0MB)
[    0.000000] efi: mem64: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bfb9b000-0x00000000bfb9d000) (0MB)
[    0.000000] efi: mem65: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bfb9d000-0x00000000bfc31000) (0MB)
[    0.000000] efi: mem66: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bfc31000-0x00000000bfc38000) (0MB)
[    0.000000] efi: mem67: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bfc38000-0x00000000bffc6000) (3MB)
[    0.000000] efi: mem68: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bffc6000-0x00000000bffcd000) (0MB)
[    0.000000] efi: mem69: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000bffcd000-0x00000000c0121000) (1MB)
[    0.000000] efi: mem70: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c0121000-0x00000000c0965000) (8MB)
[    0.000000] efi: mem71: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c0965000-0x00000000c0976000) (0MB)
[    0.000000] efi: mem72: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c0976000-0x00000000c0988000) (0MB)
[    0.000000] efi: mem73: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c0988000-0x00000000c0992000) (0MB)
[    0.000000] efi: mem74: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000c0992000-0x00000000c0e68000) (4MB)
[    0.000000] efi: mem75: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c0e68000-0x00000000c1061000) (1MB)
[    0.000000] efi: mem76: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c1061000-0x00000000c1066000) (0MB)
[    0.000000] efi: mem77: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c1066000-0x00000000c1c36000) (11MB)
[    0.000000] efi: mem78: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c1c36000-0x00000000c1c44000) (0MB)
[    0.000000] efi: mem79: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c1c44000-0x00000000c1eda000) (2MB)
[    0.000000] efi: mem80: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c1eda000-0x00000000c1ee1000) (0MB)
[    0.000000] efi: mem81: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c1ee1000-0x00000000c2929000) (10MB)
[    0.000000] efi: mem82: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c2929000-0x00000000c2935000) (0MB)
[    0.000000] efi: mem83: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c2935000-0x00000000c2957000) (0MB)
[    0.000000] efi: mem84: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c2957000-0x00000000c295c000) (0MB)
[    0.000000] efi: mem85: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c295c000-0x00000000c2969000) (0MB)
[    0.000000] efi: mem86: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c2969000-0x00000000c2970000) (0MB)
[    0.000000] efi: mem87: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c2970000-0x00000000c5000000) (38MB)
[    0.000000] efi: mem88: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c5000000-0x00000000c554d000) (5MB)
[    0.000000] efi: mem89: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c554d000-0x00000000c57b3000) (2MB)
[    0.000000] efi: mem90: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c57b3000-0x00000000c57b4000) (0MB)
[    0.000000] efi: mem91: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c57b4000-0x00000000c57b6000) (0MB)
[    0.000000] efi: mem92: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c57b6000-0x00000000c58dd000) (1MB)
[    0.000000] efi: mem93: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c58dd000-0x00000000c6000000) (7MB)
[    0.000000] efi: mem94: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c6000000-0x00000000c7db3000) (29MB)
[    0.000000] efi: mem95: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000c7db3000-0x00000000c8000000) (2MB)
[    0.000000] efi: mem96: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c8000000-0x00000000c8759000) (7MB)
[    0.000000] efi: mem97: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000c8759000-0x00000000c8800000) (0MB)
[    0.000000] efi: mem98: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c8800000-0x00000000c8f93000) (7MB)
[    0.000000] efi: mem99: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c8f93000-0x00000000c9000000) (0MB)
[    0.000000] efi: mem100: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c9000000-0x00000000ca6d4000) (22MB)
[    0.000000] efi: mem101: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000ca6d4000-0x00000000ca800000) (1MB)
[    0.000000] efi: mem102: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000ca800000-0x00000000cbcde000) (20MB)
[    0.000000] efi: mem103: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cbcde000-0x00000000cc000000) (3MB)
[    0.000000] efi: mem104: [Reserved           |RUN|  |  |  |   |  |  |  |  ] range=[0x00000000cd000000-0x00000000cf200000) (34MB)
[    0.000000] efi: mem105: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000f8000000-0x00000000fc000000) (64MB)
[    0.000000] efi: mem106: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem107: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed00000-0x00000000fed04000) (0MB)
[    0.000000] efi: mem108: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem109: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem110: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] efi: mem111: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x000000082ee00000) (29422MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Dell Inc. Precision M6800/05NG6V, BIOS A11 11/20/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x82ee00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DBFFF write-protect
[    0.000000]   DC000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7800000000 write-back
[    0.000000]   1 base 0800000000 mask 7FE0000000 write-back
[    0.000000]   2 base 0820000000 mask 7FF0000000 write-back
[    0.000000]   3 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   4 base 00D0000000 mask 7FF0000000 uncachable
[    0.000000]   5 base 00CE000000 mask 7FFE000000 uncachable
[    0.000000]   6 base 00CD000000 mask 7FFF000000 uncachable
[    0.000000]   7 base 082F000000 mask 7FFF000000 uncachable
[    0.000000]   8 base 082EE00000 mask 7FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xcd000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcbcde max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at [ffff8800000fda90]
[    0.000000] Base memory trampoline at [ffff88000008b000] 8b000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02016000, 0x02016fff] PGTABLE
[    0.000000] BRK [0x02017000, 0x02017fff] PGTABLE
[    0.000000] BRK [0x02018000, 0x02018fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x82ec00000-0x82edfffff]
[    0.000000]  [mem 0x82ec00000-0x82edfffff] page 2M
[    0.000000] BRK [0x02019000, 0x02019fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x82c000000-0x82ebfffff]
[    0.000000]  [mem 0x82c000000-0x82ebfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x800000000-0x82bffffff]
[    0.000000]  [mem 0x800000000-0x82bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbffc5fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbffc5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbffcd000-0xc0991fff]
[    0.000000]  [mem 0xbffcd000-0xbfffffff] page 4k
[    0.000000]  [mem 0xc0000000-0xc07fffff] page 2M
[    0.000000]  [mem 0xc0800000-0xc0991fff] page 4k
[    0.000000] BRK [0x0201a000, 0x0201afff] PGTABLE
[    0.000000] BRK [0x0201b000, 0x0201bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xc0e68000-0xc7db2fff]
[    0.000000]  [mem 0xc0e68000-0xc0ffffff] page 4k
[    0.000000]  [mem 0xc1000000-0xc7bfffff] page 2M
[    0.000000]  [mem 0xc7c00000-0xc7db2fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xc8000000-0xc8758fff]
[    0.000000]  [mem 0xc8000000-0xc85fffff] page 2M
[    0.000000]  [mem 0xc8600000-0xc8758fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xc8800000-0xc8f92fff]
[    0.000000]  [mem 0xc8800000-0xc8dfffff] page 2M
[    0.000000]  [mem 0xc8e00000-0xc8f92fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xc9000000-0xca6d3fff]
[    0.000000]  [mem 0xc9000000-0xca5fffff] page 2M
[    0.000000]  [mem 0xca600000-0xca6d3fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xca800000-0xcbcddfff]
[    0.000000]  [mem 0xca800000-0xcbbfffff] page 2M
[    0.000000]  [mem 0xcbc00000-0xcbcddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x7ffffffff]
[    0.000000]  [mem 0x100000000-0x7ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x3d959000-0x3fffafff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000C8FD2000 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x00000000C8FD2098 0000B4 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000C8FE4048 00010C (v05 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000C8FD21E0 011E62 (v02 DELL   CBX3     00000014 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000CA7FE080 000040
[    0.000000] ACPI: APIC 0x00000000C8FE4158 000092 (v03 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000C8FE41F0 000044 (v01 DELL   CBX3     01072009 AMI  00010013)
[    0.000000] ACPI: SLIC 0x00000000C8FE4238 000176 (v03 DELL   CBX3     01072009 MSFT 00010013)
[    0.000000] ACPI: LPIT 0x00000000C8FE43B0 00005C (v01 DELL   CBX3     00000000 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000C8FE4410 000228 (v01 INTEL  sensrhub 00000000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C8FE4638 000160 (v01 Intel  zpodd    00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C8FE4798 00051F (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C8FE4CB8 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
[    0.000000] ACPI: HPET 0x00000000C8FE5790 000038 (v01 DELL   CBX3     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000C8FE57C8 000455 (v01 SataRe SataTabl 00001000 INTL 20120711)
[    0.000000] ACPI: MCFG 0x00000000C8FE5C20 00003C (v01 DELL   CBX3     01072009 MSFT 00000097)
[    0.000000] ACPI: ASF! 0x00000000C8FE5C60 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: MSDM 0x00000000C8FE5D08 000055 (v03 DELL   CBX3     06222004 AMI  00010013)
[    0.000000] ACPI: BGRT 0x00000000C8FE5D60 000038 (v00 \xfffffff3\xffffffee              01072009 AMI  00010013)
[    0.000000] ACPI: DMAR 0x00000000C8FE5D98 0000B8 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 0x00000000C8FE5E50 0010BD (v01 SgRef  SgPeg    00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000C8FE6F10 0010BA (v01 AmdRef AmdTabl  00001000 INTL 20120711)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000082edfffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x82ede4000-0x82edf7fff]
[    0.000000]  [ffffea0000000000-ffffea0020bfffff] PMD -> [ffff88080e400000-ffff88082e3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x82edfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0004efff]
[    0.000000]   node   0: [mem 0x00050000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xbffc5fff]
[    0.000000]   node   0: [mem 0xbffcd000-0xc0991fff]
[    0.000000]   node   0: [mem 0xc0e68000-0xc7db2fff]
[    0.000000]   node   0: [mem 0xc8000000-0xc8758fff]
[    0.000000]   node   0: [mem 0xc8800000-0xc8f92fff]
[    0.000000]   node   0: [mem 0xc9000000-0xca6d3fff]
[    0.000000]   node   0: [mem 0xca800000-0xcbcddfff]
[    0.000000]   node   0: [mem 0x100000000-0x82edfffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x82edfffff]
[    0.000000] On node 0 totalpages: 8364305
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 53 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12942 pages used for memmap
[    0.000000]   DMA32 zone: 828276 pages, LIFO batch:31
[    0.000000]   Normal zone: 117688 pages used for memmap
[    0.000000]   Normal zone: 7532032 pages, LIFO batch:31
[    0.000000] tboot: non-0 tboot_addr but it is not of type E820_RESERVED
[    0.000000] Reserving Intel graphics stolen memory at 0xcd200000-0xcf1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0004f000-0x0004ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbffc6000-0xbffccfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0992000-0xc0e67fff]
[    0.000000] PM: Registered nosave memory: [mem 0xc554f000-0xc554ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc556c000-0xc556cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc556d000-0xc556dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc557c000-0xc557cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc557d000-0xc557dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc558d000-0xc558dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc558e000-0xc558efff]
[    0.000000] PM: Registered nosave memory: [mem 0xc55aa000-0xc55aafff]
[    0.000000] PM: Registered nosave memory: [mem 0xc7db3000-0xc7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc8759000-0xc87fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc8f93000-0xc8ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xca6d4000-0xca7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcbcde000-0xcbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcc000000-0xccffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcd000000-0xcf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf200000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xcf200000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:12 nr_cpumask_bits:12 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff88082ea00000 s84416 r8192 d30272 u262144
[    0.000000] pcpu-alloc: s84416 r8192 d30272 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 8233558
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0+ root=UUID=4ca78ce8-7850-4f5e-9fab-3d675e5864af ro rhgb slub_debug=- cgroup_disable=memory console=tty0 console=ttyS0,115200n8 radeon.dpm=1 intel_iommu=on vfio_iommu_type1.allow_unsafe_interrupts=1 zswap.zpool=zsmalloc zswap.enabled=1 zram=1
[    0.000000] Disabling memory control group subsystem
[    0.000000] Intel-IOMMU: enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Memory: 32698856K/33457220K available (7558K kernel code, 1192K rwdata, 3256K rodata, 1472K init, 1476K bss, 758364K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=12 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:4352 nr_irqs:488 0
[    0.000000]  Offload RCU callbacks from all CPUs
[    0.000000]  Offload RCU callbacks from CPUs: 0-7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] tsc: Detected 2893.331 MHz processor
[    0.000019] Calibrating delay loop (skipped), value calculated using timer frequency.. 5786.66 BogoMIPS (lpj=2893331)
[    0.000557] pid_max: default: 32768 minimum: 301
[    0.000785] ACPI: Core revision 20140926
[    0.011247] ACPI: All ACPI Tables successfully acquired
[    0.013266] Security Framework initialized
[    0.013478] SELinux:  Initializing.
[    0.013675] SELinux:  Starting in permissive mode
[    0.015080] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.019396] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.021398] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.021778] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.022349] Initializing cgroup subsys memory
[    0.022589] Initializing cgroup subsys devices
[    0.022808] Initializing cgroup subsys freezer
[    0.023026] Initializing cgroup subsys net_cls
[    0.023243] Initializing cgroup subsys blkio
[    0.023451] Initializing cgroup subsys perf_event
[    0.023696] Initializing cgroup subsys net_prio
[    0.023918] Initializing cgroup subsys hugetlb
[    0.024150] CPU: Physical Processor ID: 0
[    0.024351] CPU: Processor Core ID: 0
[    0.024548] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.025885] mce: CPU supports 9 MCE banks
[    0.026096] CPU0: Thermal monitoring enabled (TM1)
[    0.026343] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.027059] Freeing SMP alternatives memory: 28K (ffffffff81e9c000 - ffffffff81ea3000)
[    0.028072] Ignoring BGRT: invalid status 0 (expected 1)
[    0.030697] ftrace: allocating 27378 entries in 107 pages
[    0.038676] dmar: Host address width 39
[    0.038871] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.039136] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
[    0.039548] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.039808] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008020660462 ecap f010da
[    0.040196] dmar: RMRR base: 0x000000c7f19000 end: 0x000000c7f27fff
[    0.040512] dmar: RMRR base: 0x000000cd000000 end: 0x000000cf1fffff
[    0.040878] IOAPIC id 8 under DRHD base  0xfed91000 IOMMU 1
[    0.041147] HPET id 0 under DRHD base 0xfed91000
[    0.041373] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.041750] dmar: DRHD: handling fault status reg 2
[    0.041988] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr cbcef000 
DMAR:[fault reason 06] PTE Read access is not set                                                                                                                                
[    0.042708] Enabled IRQ remapping in x2apic mode
[    0.042937] Enabling x2apic
[    0.043078] Enabled x2apic
[    0.043223] Switched APIC routing to cluster x2apic.
[    0.043900] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.054192] smpboot: CPU0: Intel(R) Core(TM) i7-4910MQ CPU @ 2.90GHz (fam: 06, model: 3c, stepping: 03)
[    0.054676] TSC deadline timer enabled
[    0.054693] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.055233] ... version:                3
[    0.055428] ... bit width:              48
[    0.055629] ... generic registers:      4
[    0.055826] ... value mask:             0000ffffffffffff
[    0.056083] ... max period:             0000ffffffffffff
[    0.056341] ... fixed-purpose events:   3
[    0.056538] ... event mask:             000000070000000f
[    0.057656] x86: Booting SMP configuration:
[    0.057868] .... node  #0, CPUs:      #1
[    0.071950] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.072416]  #2 #3 #4 #5 #6 #7
[    0.158937] x86: Booted up 1 node, 8 CPUs
[    0.159159] smpboot: Total of 8 processors activated (46293.29 BogoMIPS)
[    0.165969] devtmpfs: initialized
[    0.168750] PM: Registering ACPI NVS region [mem 0xbffc6000-0xbffccfff] (28672 bytes)
[    0.169132] PM: Registering ACPI NVS region [mem 0xca6d4000-0xca7fffff] (1228800 bytes)
[    0.170058] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.170400] pinctrl core: initialized pinctrl subsystem
[    0.170691] RTC time: 23:50:03, date: 12/15/14
[    0.170979] NET: Registered protocol family 16
[    0.173428] cpuidle: using governor menu
[    0.173724] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.174100] ACPI: bus type PCI registered
[    0.174301] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.174675] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.175145] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.175520] PCI: Using configuration type 1 for base access
[    0.175801] dmi type 0xB1 record - unknown flag
[    0.180100] ACPI: Added _OSI(Module Device)
[    0.180316] ACPI: Added _OSI(Processor Device)
[    0.180539] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.180773] ACPI: Added _OSI(Processor Aggregator Device)
[    0.183654] ACPI: Executed 2 blocks of module-level executable AML code
[    0.194076] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.254220] ACPI: Dynamic OEM Table Load:
[    0.254449] ACPI: SSDT 0xFFFF88080A68C800 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
[    0.258321] ACPI: Dynamic OEM Table Load:
[    0.258546] ACPI: SSDT 0xFFFF88080A683000 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
[    0.262218] ACPI: Dynamic OEM Table Load:
[    0.262443] ACPI: SSDT 0xFFFF88080A700E00 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
[    0.274190] ACPI: Interpreter enabled
[    0.274386] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.274863] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.275351] ACPI: (supports S0 S3 S4 S5)
[    0.275565] ACPI: Using IOAPIC for interrupt routing
[    0.275824] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.461434] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.461750] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.462333] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.462778] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.463539] PCI host bridge to bus 0000:00
[    0.463744] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.464013] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.464327] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.464632] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.464968] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.465316] pci_bus 0000:00: root bus resource [mem 0xcf200000-0xfeafffff]
[    0.465651] pci 0000:00:00.0: [8086:0c04] type 00 class 0x060000
[    0.465723] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.465748] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.465787] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.466094] pci 0000:00:02.0: [8086:0416] type 00 class 0x030000
[    0.466101] pci 0000:00:02.0: reg 0x10: [mem 0xf5800000-0xf5bfffff 64bit]
[    0.466105] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.466108] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.466165] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.466170] pci 0000:00:03.0: reg 0x10: [mem 0xf7d34000-0xf7d37fff 64bit]
[    0.466265] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.466282] pci 0000:00:14.0: reg 0x10: [mem 0xf7d20000-0xf7d2ffff 64bit]
[    0.466339] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.466377] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.466693] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.466710] pci 0000:00:16.0: reg 0x10: [mem 0xf7d40000-0xf7d4000f 64bit]
[    0.466769] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.466836] pci 0000:00:16.3: [8086:8c3d] type 00 class 0x070002
[    0.466848] pci 0000:00:16.3: reg 0x10: [io  0xf0e0-0xf0e7]
[    0.466854] pci 0000:00:16.3: reg 0x14: [mem 0xf7d3e000-0xf7d3efff]
[    0.466969] pci 0000:00:19.0: [8086:153a] type 00 class 0x020000
[    0.466984] pci 0000:00:19.0: reg 0x10: [mem 0xf7d00000-0xf7d1ffff]
[    0.466991] pci 0000:00:19.0: reg 0x14: [mem 0xf7d3d000-0xf7d3dfff]
[    0.466998] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.467052] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.472373] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.472698] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.472718] pci 0000:00:1a.0: reg 0x10: [mem 0xf7d3c000-0xf7d3c3ff]
[    0.472802] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.472848] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.473168] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.473183] pci 0000:00:1b.0: reg 0x10: [mem 0xf7d30000-0xf7d33fff 64bit]
[    0.473247] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.473290] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.473608] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.473671] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.473689] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    0.473926] pci 0000:00:1c.0: Intel PCH root port ACS workaround enabled
[    0.474291] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.474597] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
[    0.474656] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.474672] pci 0000:00:1c.2: Enabling MPC IRBNCE
[    0.474903] pci 0000:00:1c.2: Intel PCH root port ACS workaround enabled
[    0.475268] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.475585] pci 0000:00:1c.3: [8086:8c16] type 01 class 0x060400
[    0.475649] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.475667] pci 0000:00:1c.3: Enabling MPC IRBNCE
[    0.475902] pci 0000:00:1c.3: Intel PCH root port ACS workaround enabled
[    0.476267] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.476570] pci 0000:00:1c.4: [8086:8c18] type 01 class 0x060400
[    0.476637] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.476654] pci 0000:00:1c.4: Enabling MPC IRBNCE
[    0.476884] pci 0000:00:1c.4: Intel PCH root port ACS workaround enabled
[    0.477245] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.477563] pci 0000:00:1c.6: [8086:8c1c] type 01 class 0x060400
[    0.477635] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.477653] pci 0000:00:1c.6: Enabling MPC IRBNCE
[    0.477889] pci 0000:00:1c.6: Intel PCH root port ACS workaround enabled
[    0.478253] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.478560] pci 0000:00:1c.7: [8086:8c1e] type 01 class 0x060400
[    0.478627] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.478644] pci 0000:00:1c.7: Enabling MPC IRBNCE
[    0.478876] pci 0000:00:1c.7: Intel PCH root port ACS workaround enabled
[    0.479226] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.479531] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.479548] pci 0000:00:1d.0: reg 0x10: [mem 0xf7d3b000-0xf7d3b3ff]
[    0.479626] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.479662] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.479972] pci 0000:00:1f.0: [8086:8c4f] type 00 class 0x060100
[    0.480117] pci 0000:00:1f.2: [8086:282a] type 00 class 0x010400
[    0.480129] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.480136] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.480141] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.480148] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.480154] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.480160] pci 0000:00:1f.2: reg 0x24: [mem 0xf7d3a000-0xf7d3a7ff]
[    0.480191] pci 0000:00:1f.2: PME# supported from D3hot
[    0.480248] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.480260] pci 0000:00:1f.3: reg 0x10: [mem 0xf7d39000-0xf7d390ff 64bit]
[    0.480276] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.480376] pci 0000:01:00.0: [1002:6640] type 00 class 0x030000
[    0.480388] pci 0000:01:00.0: reg 0x10: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.480396] pci 0000:01:00.0: reg 0x18: [mem 0xf0000000-0xf07fffff 64bit pref]
[    0.480401] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.480406] pci 0000:01:00.0: reg 0x24: [mem 0xf7c00000-0xf7c3ffff]
[    0.480412] pci 0000:01:00.0: reg 0x30: [mem 0xf7c40000-0xf7c5ffff pref]
[    0.480467] pci 0000:01:00.0: supports D1 D2
[    0.480468] pci 0000:01:00.0: PME# supported from D1 D2 D3hot
[    0.480498] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.480805] pci 0000:01:00.1: [1002:aac0] type 00 class 0x040300
[    0.480819] pci 0000:01:00.1: reg 0x10: [mem 0xf7c60000-0xf7c63fff 64bit]
[    0.480894] pci 0000:01:00.1: supports D1 D2
[    0.480915] pci 0000:01:00.1: System wakeup disabled by ACPI
[    0.482794] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.483047] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.483049] pci 0000:00:01.0:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.483051] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf07fffff 64bit pref]
[    0.483110] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.483469] pci 0000:03:00.0: [8086:08b1] type 00 class 0x028000
[    0.483517] pci 0000:03:00.0: reg 0x10: [mem 0xf7b00000-0xf7b01fff 64bit]
[    0.483729] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.483799] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.485822] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.486072] pci 0000:00:1c.2:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.486128] pci 0000:00:1c.3: PCI bridge to [bus 04-07]
[    0.486389] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.486392] pci 0000:00:1c.3:   bridge window [mem 0xf7000000-0xf79fffff]
[    0.486397] pci 0000:00:1c.3:   bridge window [mem 0xf1d00000-0xf26fffff 64bit pref]
[    0.486451] pci 0000:00:1c.4: PCI bridge to [bus 08]
[    0.486698] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.486702] pci 0000:00:1c.4:   bridge window [mem 0xf6600000-0xf6ffffff]
[    0.486707] pci 0000:00:1c.4:   bridge window [mem 0xf1300000-0xf1cfffff 64bit pref]
[    0.486772] acpiphp: Slot [1] registered
[    0.486974] pci 0000:00:1c.6: PCI bridge to [bus 09-10]
[    0.487236] pci 0000:00:1c.6:   bridge window [io  0xa000-0xbfff]
[    0.487239] pci 0000:00:1c.6:   bridge window [mem 0xf5c00000-0xf65fffff]
[    0.487244] pci 0000:00:1c.6:   bridge window [mem 0xf0900000-0xf12fffff 64bit pref]
[    0.487395] pci 0000:11:00.0: [1217:8520] type 00 class 0x080501
[    0.487414] pci 0000:11:00.0: reg 0x10: [mem 0xf7a01000-0xf7a01fff]
[    0.487425] pci 0000:11:00.0: reg 0x14: [mem 0xf7a00000-0xf7a007ff]
[    0.487541] pci 0000:11:00.0: PME# supported from D3hot D3cold
[    0.487574] pci 0000:11:00.0: System wakeup disabled by ACPI
[    0.489054] pci 0000:00:1c.7: PCI bridge to [bus 11]
[    0.489303] pci 0000:00:1c.7:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.489353] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.508360] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.508830] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.509297] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.509764] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.510216] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.510664] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.511115] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.511564] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.542332] ACPI: Enabled 2 GPEs in block 00 to 3F
[    0.542624] ACPI : EC: GPE = 0x10, I/O: command/status = 0x934, data = 0x930
[    0.543040] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.543327] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.543727] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.544113] vgaarb: loaded
[    0.544257] vgaarb: bridge control possible 0000:01:00.0
[    0.544515] vgaarb: no bridge control possible 0000:00:02.0
[    0.544822] SCSI subsystem initialized
[    0.545031] libata version 3.00 loaded.
[    0.545048] ACPI: bus type USB registered
[    0.545254] usbcore: registered new interface driver usbfs
[    0.545522] usbcore: registered new interface driver hub
[    0.545793] usbcore: registered new device driver usb
[    0.546125] PCI: Using ACPI for IRQ routing
[    0.547438] PCI: pci_cache_line_size set to 64 bytes
[    0.547492] e820: reserve RAM buffer [mem 0x0004f000-0x0004ffff]
[    0.547492] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.547493] e820: reserve RAM buffer [mem 0xbffc6000-0xbfffffff]
[    0.547494] e820: reserve RAM buffer [mem 0xc0992000-0xc3ffffff]
[    0.547494] e820: reserve RAM buffer [mem 0xc554f018-0xc7ffffff]
[    0.547495] e820: reserve RAM buffer [mem 0xc556d018-0xc7ffffff]
[    0.547496] e820: reserve RAM buffer [mem 0xc557d018-0xc7ffffff]
[    0.547497] e820: reserve RAM buffer [mem 0xc558e018-0xc7ffffff]
[    0.547498] e820: reserve RAM buffer [mem 0xc7db3000-0xc7ffffff]
[    0.547498] e820: reserve RAM buffer [mem 0xc8759000-0xcbffffff]
[    0.547499] e820: reserve RAM buffer [mem 0xc8f93000-0xcbffffff]
[    0.547500] e820: reserve RAM buffer [mem 0xca6d4000-0xcbffffff]
[    0.547501] e820: reserve RAM buffer [mem 0xcbcde000-0xcbffffff]
[    0.547502] e820: reserve RAM buffer [mem 0x82ee00000-0x82fffffff]
[    0.547567] NetLabel: Initializing
[    0.547737] NetLabel:  domain hash size = 128
[    0.547952] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.548200] NetLabel:  unlabeled traffic allowed by default
[    0.548510] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.548886] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.551195] Switched to clocksource hpet
[    0.555303] pnp: PnP ACPI init
[    0.555507] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.555827] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.555920] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.556212] system 00:01: [io  0xffff] has been reserved
[    0.556479] system 00:01: [io  0xffff] has been reserved
[    0.556739] system 00:01: [io  0xffff] has been reserved
[    0.557002] system 00:01: [io  0x1c00-0x1cfe] has been reserved
[    0.557298] system 00:01: [io  0x1d00-0x1dfe] has been reserved
[    0.557596] system 00:01: [io  0x1e00-0x1efe] has been reserved
[    0.557882] system 00:01: [io  0x1f00-0x1ffe] has been reserved
[    0.558168] system 00:01: [io  0x1800-0x18fe] could not be reserved
[    0.558483] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.558776] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.558799] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.558832] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.559126] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.559158] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.559464] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.559486] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.559501] pnp 00:06: Plug and Play ACPI device, IDs DLL05cd PNP0f13 (active)
[    0.577288] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    0.577663] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.577990] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.578323] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.578647] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.578980] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.579308] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.579642] system 00:08: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.579984] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.580312] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.580643] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.580979] system 00:08: [mem 0xf7fdf000-0xf7fdffff] has been reserved
[    0.581301] system 00:08: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    0.581619] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.623273] pnp: PnP ACPI: found 9 devices
[    0.629488] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.629733] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.630028] pci 0000:00:01.0:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.630359] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf07fffff 64bit pref]
[    0.630734] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.630983] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.631231] pci 0000:00:1c.2:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.631564] pci 0000:00:1c.3: PCI bridge to [bus 04-07]
[    0.631819] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.632117] pci 0000:00:1c.3:   bridge window [mem 0xf7000000-0xf79fffff]
[    0.632450] pci 0000:00:1c.3:   bridge window [mem 0xf1d00000-0xf26fffff 64bit pref]
[    0.632826] pci 0000:00:1c.4: PCI bridge to [bus 08]
[    0.633068] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.633369] pci 0000:00:1c.4:   bridge window [mem 0xf6600000-0xf6ffffff]
[    0.633699] pci 0000:00:1c.4:   bridge window [mem 0xf1300000-0xf1cfffff 64bit pref]
[    0.634073] pci 0000:00:1c.6: PCI bridge to [bus 09-10]
[    0.634330] pci 0000:00:1c.6:   bridge window [io  0xa000-0xbfff]
[    0.634628] pci 0000:00:1c.6:   bridge window [mem 0xf5c00000-0xf65fffff]
[    0.634957] pci 0000:00:1c.6:   bridge window [mem 0xf0900000-0xf12fffff 64bit pref]
[    0.635337] pci 0000:00:1c.7: PCI bridge to [bus 11]
[    0.635581] pci 0000:00:1c.7:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.635914] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.635915] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.635916] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.635916] pci_bus 0000:00: resource 7 [mem 0x000dc000-0x000dffff]
[    0.635917] pci_bus 0000:00: resource 8 [mem 0xcf200000-0xfeafffff]
[    0.635918] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.635919] pci_bus 0000:01: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.635920] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf07fffff 64bit pref]
[    0.635921] pci_bus 0000:03: resource 1 [mem 0xf7b00000-0xf7bfffff]
[    0.635922] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.635923] pci_bus 0000:04: resource 1 [mem 0xf7000000-0xf79fffff]
[    0.635924] pci_bus 0000:04: resource 2 [mem 0xf1d00000-0xf26fffff 64bit pref]
[    0.635925] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
[    0.635925] pci_bus 0000:08: resource 1 [mem 0xf6600000-0xf6ffffff]
[    0.635926] pci_bus 0000:08: resource 2 [mem 0xf1300000-0xf1cfffff 64bit pref]
[    0.635927] pci_bus 0000:09: resource 0 [io  0xa000-0xbfff]
[    0.635928] pci_bus 0000:09: resource 1 [mem 0xf5c00000-0xf65fffff]
[    0.635929] pci_bus 0000:09: resource 2 [mem 0xf0900000-0xf12fffff 64bit pref]
[    0.635930] pci_bus 0000:11: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.635948] NET: Registered protocol family 2
[    0.636350] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.636935] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.637360] TCP: Hash tables configured (established 262144 bind 65536)
[    0.637685] TCP: reno registered
[    0.637865] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.638238] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.638636] NET: Registered protocol family 1
[    0.638860] pci 0000:00:02.0: Video device with shadowed ROM
[    0.639192] PCI: CLS 64 bytes, default 64
[    0.639232] Unpacking initramfs...
[    1.013856] Freeing initrd memory: 39560K (ffff88003d959000 - ffff88003fffb000)
[    1.014245] DMAR: No ATSR found
[    1.014433] IOMMU 0 0xfed90000: using Queued invalidation
[    1.014697] IOMMU 1 0xfed91000: using Queued invalidation
[    1.014960] IOMMU: Setting RMRR:
[    1.015127] IOMMU: Setting identity map for device 0000:00:02.0 [0xcd000000 - 0xcf1fffff]
[    1.015685] IOMMU: Setting identity map for device 0000:00:14.0 [0xc7f19000 - 0xc7f27fff]
[    1.016100] IOMMU: Setting identity map for device 0000:00:1a.0 [0xc7f19000 - 0xc7f27fff]
[    1.016513] IOMMU: Setting identity map for device 0000:00:1d.0 [0xc7f19000 - 0xc7f27fff]
[    1.016915] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    1.017178] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    1.017655] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    1.019714] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    1.020247] microcode: CPU0 sig=0x306c3, pf=0x10, revision=0x1c
[    1.020547] microcode: CPU1 sig=0x306c3, pf=0x10, revision=0x1c
[    1.020844] microcode: CPU2 sig=0x306c3, pf=0x10, revision=0x1c
[    1.021137] microcode: CPU3 sig=0x306c3, pf=0x10, revision=0x1c
[    1.021434] microcode: CPU4 sig=0x306c3, pf=0x10, revision=0x1c
[    1.021722] microcode: CPU5 sig=0x306c3, pf=0x10, revision=0x1c
[    1.022014] microcode: CPU6 sig=0x306c3, pf=0x10, revision=0x1c
[    1.022308] microcode: CPU7 sig=0x306c3, pf=0x10, revision=0x1c
[    1.022629] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.023395] AVX2 version of gcm_enc/dec engaged.
[    1.023631] AES CTR mode by8 optimization enabled
[    1.025218] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    1.025854] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.026184] Initialise system trusted keyring
[    1.026424] audit: initializing netlink subsys (disabled)
[    1.026707] audit: type=2000 audit(1418687403.999:1): initialized
[    1.027216] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.028427] zpool: loaded
[    1.028694] VFS: Disk quotas dquot_6.5.2
[    1.028906] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.029429] msgmni has been set to 32768
[    1.029652] Key type big_key registered
[    1.029842] SELinux:  Registering netfilter hooks
[    1.030653] alg: No test for stdrng (krng)
[    1.030861] NET: Registered protocol family 38
[    1.031081] Key type asymmetric registered
[    1.031295] Asymmetric key parser 'x509' registered
[    1.031569] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.031972] io scheduler noop registered
[    1.032179] io scheduler deadline registered
[    1.032416] io scheduler cfq registered (default)
[    1.032791] pcieport 0000:00:01.0: irq 26 for MSI/MSI-X
[    1.033243] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.033533] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.033887] efifb: probing for efifb
[    1.034071] efifb: framebuffer at 0xd0000000, mapped to 0xffffc90007780000, using 1876k, total 1875k
[    1.034512] efifb: mode is 800x600x32, linelength=3200, pages=1
[    1.034797] efifb: scrolling: redraw
[    1.034975] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.035914] Console: switching to colour frame buffer device 100x37
[    1.036882] fb0: EFI VGA frame buffer device
[    1.037106] intel_idle: MWAIT substates: 0x42120
[    1.037107] intel_idle: v0.4 model 0x3C
[    1.037108] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.037983] ACPI: AC Adapter [AC] (on-line)
[    1.038255] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    1.039103] ACPI: Lid Switch [LID0]
[    1.039323] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.039754] ACPI: Power Button [PBTN]
[    1.039971] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    1.040731] ACPI: Sleep Button [SBTN]
[    1.041271] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.041980] ACPI: Power Button [PWRF]
[    1.071458] thermal LNXTHERM:00: registered as thermal_zone0
[    1.072141] ACPI: Thermal Zone [THM] (25 C)
[    1.072805] GHES: HEST is not enabled!
[    1.073556] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.074646] serial 0000:00:16.3: enabling device (0000 -> 0003)
[    1.075496] console [ttyS0] disabled
[    1.086691] ACPI: Battery Slot [BAT0] (battery present)
[    1.096453] serial 0000:00:16.3: ttyS0 at I/O 0xf0e0 (irq = 19, base_baud = 115200) is a 16550A
[    2.021554] tsc: Refined TSC clocksource calibration: 2893.300 MHz
[    3.072354] Switched to clocksource tsc
[    3.072355] console [ttyS0] enabled
[    3.084059] Non-volatile memory driver v1.3
[    3.086318] Linux agpgart interface v0.103
[    3.088332] ahci 0000:00:1f.2: version 3.0
[    3.093159] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    3.093183] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    3.096791] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0xf impl RAID mode
[    3.099535] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pio slum part ems sxs apst 
[    3.108370] ACPI: Battery Slot [BAT1] (battery absent)
[    3.109387] scsi host0: ahci
[    3.109572] scsi host1: ahci
[    3.109695] scsi host2: ahci
[    3.109807] scsi host3: ahci
[    3.109854] scsi host4: ahci
[    3.109900] scsi host5: ahci
[    3.109929] ata1: SATA max UDMA/133 abar m2048@0xf7d3a000 port 0xf7d3a100 irq 27
[    3.109931] ata2: SATA max UDMA/133 abar m2048@0xf7d3a000 port 0xf7d3a180 irq 27
[    3.109932] ata3: SATA max UDMA/133 abar m2048@0xf7d3a000 port 0xf7d3a200 irq 27
[    3.109934] ata4: SATA max UDMA/133 abar m2048@0xf7d3a000 port 0xf7d3a280 irq 27
[    3.109934] ata5: DUMMY
[    3.109935] ata6: DUMMY
[    3.110004] libphy: Fixed MDIO Bus: probed
[    3.110155] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.110180] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    3.110297] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    3.110314] xhci_hcd 0000:00:14.0: irq 28 for MSI/MSI-X
[    3.110364] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.110365] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.110366] usb usb1: Product: xHCI Host Controller
[    3.110366] usb usb1: Manufacturer: Linux 3.18.0+ xhci-hcd
[    3.110367] usb usb1: SerialNumber: 0000:00:14.0
[    3.110443] hub 1-0:1.0: USB hub found
[    3.110463] hub 1-0:1.0: 15 ports detected
[    3.113657] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.113680] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    3.113715] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    3.113716] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.113717] usb usb2: Product: xHCI Host Controller
[    3.113718] usb usb2: Manufacturer: Linux 3.18.0+ xhci-hcd
[    3.113718] usb usb2: SerialNumber: 0000:00:14.0
[    3.113802] hub 2-0:1.0: USB hub found
[    3.113815] hub 2-0:1.0: 6 ports detected
[    3.114723] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.114728] ehci-pci: EHCI PCI platform driver
[    3.114810] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    3.114860] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.114870] ehci-pci 0000:00:1a.0: debug port 2
[    3.118794] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    3.118806] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7d3c000
[    3.124775] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.124797] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    3.124798] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.124799] usb usb3: Product: EHCI Host Controller
[    3.124799] usb usb3: Manufacturer: Linux 3.18.0+ ehci_hcd
[    3.124800] usb usb3: SerialNumber: 0000:00:1a.0
[    3.124882] hub 3-0:1.0: USB hub found
[    3.124885] hub 3-0:1.0: 3 ports detected
[    3.125040] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    3.125081] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    3.125092] ehci-pci 0000:00:1d.0: debug port 2
[    3.128990] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    3.129001] ehci-pci 0000:00:1d.0: irq 21, io mem 0xf7d3b000
[    3.133776] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.133803] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    3.133804] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.133805] usb usb4: Product: EHCI Host Controller
[    3.133806] usb usb4: Manufacturer: Linux 3.18.0+ ehci_hcd
[    3.133807] usb usb4: SerialNumber: 0000:00:1d.0
[    3.133902] hub 4-0:1.0: USB hub found
[    3.133905] hub 4-0:1.0: 3 ports detected
[    3.134014] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.134018] ohci-pci: OHCI PCI platform driver
[    3.134027] uhci_hcd: USB Universal Host Controller Interface driver
[    3.134077] usbcore: registered new interface driver usbserial
[    3.134084] usbcore: registered new interface driver usbserial_generic
[    3.134088] usbserial: USB Serial support registered for generic
[    3.134117] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.134598] i8042: Warning: Keylock active
[    3.137020] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.137022] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.137101] mousedev: PS/2 mouse device common for all mice
[    3.137298] rtc_cmos 00:02: RTC can wake from S4
[    3.137440] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.137465] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.137513] device-mapper: uevent: version 1.0.3
[    3.137555] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17) initialised: dm-devel@redhat.com
[    3.137584] Intel P-state driver initializing.
[    3.140345] EFI Variables Facility v0.08 2004-May-17
[    3.141415] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    3.146075] hidraw: raw HID events driver (C) Jiri Kosina
[    3.146337] usbcore: registered new interface driver usbhid
[    3.146338] usbhid: USB HID core driver
[    3.146421] drop_monitor: Initializing network drop monitor service
[    3.146612] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.150955] TCP: cubic registered
[    3.150971] Initializing XFRM netlink socket
[    3.151046] NET: Registered protocol family 10
[    3.151229] mip6: Mobile IPv6
[    3.151231] NET: Registered protocol family 17
[    3.151571] Loading compiled-in X.509 certificates
[    3.152217] Loaded X.509 cert 'Magrathea: Glacier signing key: 83f8966e45639130b6b475cda58f75f9110b2015'
[    3.152226] registered taskstats version 1
[    3.152240] zswap: loading zswap
[    3.152241] zpool: creating pool type zsmalloc
[    3.152251] zpool: created zsmalloc pool
[    3.152252] zswap: using zsmalloc pool
[    3.152256] zswap: using lzo compressor
[    3.152835]   Magic number: 10:393:858
[    3.153886] rtc_cmos 00:02: setting system clock to 2014-12-15 23:50:06 UTC (1418687406)
[    3.153965] PM: Hibernation image not present or could not be loaded.
[    3.414897] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.426904] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    3.438913] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    3.465913] usb 1-2: new high-speed USB device number 2 using xhci_hcd
[    3.473759] ata1.00: ATA-9: ST1000LM014-1EJ164, DEMA, max UDMA/133
[    3.477467] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.529236] ata1.00: configured for UDMA/133
[    3.531740] scsi 0:0:0:0: Direct-Access     ATA      ST1000LM014-1EJ1 DEMA PQ: 0 ANSI: 5
[    3.536359] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.536403] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.544062] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    3.547454] sd 0:0:0:0: [sda] Write Protect is off
[    3.550465] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.550489] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.555909] usb 3-1: New USB device found, idVendor=8087, idProduct=8008
[    3.559412] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.559483]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7
[    3.559841] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.570354] usb 4-1: New USB device found, idVendor=8087, idProduct=8000
[    3.574119] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.578302] hub 3-1:1.0: USB hub found
[    3.581116] hub 4-1:1.0: USB hub found
[    3.583568] hub 3-1:1.0: 6 ports detected
[    3.586387] hub 4-1:1.0: 8 ports detected
[    3.770554] usb 1-2: New USB device found, idVendor=046d, idProduct=0990
[    3.774484] usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=2
[    3.778776] usb 1-2: SerialNumber: B4261720
[    3.840992] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.846966] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GU90N, A1B0, max UDMA/100
[    3.854587] ata2.00: configured for UDMA/100
[    3.861742] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GU90N    A1B0 PQ: 0 ANSI: 5
[    3.864014] usb 3-1.5: new high-speed USB device number 3 using ehci-pci
[    3.865892] usb 4-1.5: new full-speed USB device number 3 using ehci-pci
[    3.900593] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.904701] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.907167] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.907292] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.935022] usb 1-3: new full-speed USB device number 3 using xhci_hcd
[    3.953057] usb 4-1.5: New USB device found, idVendor=8087, idProduct=07dc
[    3.957078] usb 4-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.023726] usb 3-1.5: New USB device found, idVendor=0c45, idProduct=64d0
[    4.025972] usb 3-1.5: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[    4.029553] usb 3-1.5: Product: Laptop_Integrated_Webcam_HD
[    4.032031] usb 3-1.5: Manufacturer: CN0767N97248749MBFH0A01
[    4.101517] usb 1-3: New USB device found, idVendor=0557, idProduct=7000
[    4.105539] usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.109813] usb 1-3: ep 0x81 - rounding interval to 1024 microframes, ep desc says 2040 microframes
[    4.115233] hub 1-3:1.0: USB hub found
[    4.117765] hub 1-3:1.0: 4 ports detected
[    4.214071] ata3: SATA link down (SStatus 0 SControl 300)
[    4.382171] usb 1-3.1: new low-speed USB device number 4 using xhci_hcd
[    4.518341] usb 1-3.1: New USB device found, idVendor=0557, idProduct=2213
[    4.521106] ata4: SATA link down (SStatus 0 SControl 300)
[    4.525948] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.530063] usb 1-3.1: Product: CS-1734A V4.2.417
[    4.530534] Freeing unused kernel memory: 1472K (ffffffff81d2c000 - ffffffff81e9c000)
[    4.530534] Write protecting the kernel read-only data: 12288k
[    4.541268] usb 1-3.1: Manufacturer: ATEN
[    4.544122] Freeing unused kernel memory: 620K (ffff880001765000 - ffff880001800000)
[    4.544443] usb 1-3.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    4.544445] usb 1-3.1: ep 0x83 - rounding interval to 32 microframes, ep desc says 40 microframes
[    4.559645] Freeing unused kernel memory: 840K (ffff880001b2e000 - ffff880001c00000)
[    4.571000] input: ATEN CS-1734A V4.2.417 as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3.1/1-3.1:1.0/0003:0557:2213.0001/input/input8
[    4.571134] random: systemd urandom read with 47 bits of entropy available
[    4.581640] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input7
[    4.586058] systemd[1]: systemd 217 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN )
[    4.586165] hid-generic 0003:0557:2213.0001: input,hidraw0: USB HID v1.00 Keyboard [ATEN CS-1734A V4.2.417] on usb-0000:00:14.0-3.1/input0
[    4.602525] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input6
[    4.604929] input: ATEN CS-1734A V4.2.417 as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3.1/1-3.1:1.1/0003:0557:2213.0002/input/input9
[    4.605182] hid-generic 0003:0557:2213.0002: input,hidraw1: USB HID v1.00 Mouse [ATEN CS-1734A V4.2.417] on usb-0000:00:14.0-3.1/input1
[    4.617826] systemd[1]: Detected architecture 'x86-64'.
[    4.620610] systemd[1]: Running in initial RAM disk.
[    4.625311] systemd[1]: Set hostname to <segfault.sh0n.net>.
[    4.652368] systemd[1]: Expecting device dev-disk-by\x2duuid-5A5D\x2dCA4C.device...
[    4.658221] systemd[1]: Expecting device dev-disk-by\x2duuid-ee2ce425\x2dc958\x2d4d81\x2da195\x2d03b5089e9d60.device...
[    4.664241] systemd[1]: Expecting device dev-disk-by\x2duuid-4ca78ce8\x2d7850\x2d4f5e\x2d9fab\x2d3d675e5864af.device...
[    4.672221] systemd[1]: Starting Timers.
[    4.676184] systemd[1]: Reached target Timers.
[    4.678579] systemd[1]: Starting -.slice.
[    4.685143] systemd[1]: Created slice -.slice.
[    4.687531] systemd[1]: Starting udev Kernel Socket.
[    4.691143] systemd[1]: Listening on udev Kernel Socket.
[    4.692960] systemd[1]: Starting udev Control Socket.
[    4.697143] systemd[1]: Listening on udev Control Socket.
[    4.700325] systemd[1]: Starting Journal Socket.
[    4.704144] systemd[1]: Listening on Journal Socket.
[    4.706546] systemd[1]: Starting System Slice.
[    4.710188] systemd[1]: Created slice System Slice.
[    4.712735] systemd[1]: Started dracut ask for additional cmdline parameters.
[    4.716299] systemd[1]: Starting dracut cmdline hook...
[    4.720551] systemd[1]: Starting system-systemd\x2dfsck.slice.
[    4.725180] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    4.728353] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    4.734467] systemd[1]: Started Load Kernel Modules.
[    4.736685] systemd[1]: Starting Apply Kernel Variables...
[    4.741411] systemd[1]: Starting Journal Socket (/dev/log).
[    4.744483] systemd[1]: Starting Slices.
[    4.748167] systemd[1]: Reached target Slices.
[    4.750014] systemd[1]: Starting Setup Virtual Console...
[    4.754417] systemd[1]: Starting Swap.
[    4.758179] systemd[1]: Reached target Swap.
[    4.758193] systemd[1]: Starting Local File Systems.
[    4.764182] systemd[1]: Reached target Local File Systems.
[    4.768171] systemd[1]: Started dracut cmdline hook.
[    4.773166] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    4.779166] systemd[1]: Started Apply Kernel Variables.
[    4.783168] systemd[1]: Listening on Journal Socket (/dev/log).
[    4.789893] systemd[1]: Starting Sockets.
[    4.793190] systemd[1]: Reached target Sockets.
[    4.795055] systemd[1]: Starting Journal Service...
[    4.798487] systemd[1]: Starting Create Static Device Nodes in /dev...
[    4.804416] systemd[1]: Starting dracut pre-udev hook...
[    4.810193] systemd[1]: Started Create Static Device Nodes in /dev.
[    4.815181] systemd[1]: Started Journal Service.
[    4.862257] pps_core: LinuxPPS API ver. 1 registered
[    4.864314] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    4.874078] sdhci: Secure Digital Host Controller Interface driver
[    4.876780] sdhci: Copyright(c) Pierre Ossman
[    4.878915] PTP clock support registered
[    4.902432] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    4.905566] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    4.908085] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.908300] [drm] Initialized drm 1.1.0 20060810
[    4.914320] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    5.079984] e1000e 0000:00:19.0 eth0: registered PHC clock
[    5.082790] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 34:e6:d7:10:aa:a8
[    5.086544] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.086592] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    5.092975] e1000e 0000:00:19.0 eno1: renamed from eth0
[    5.110860] [drm] radeon kernel modesetting enabled.
[    5.114669] VGA switcheroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
[    5.119481] checking generic (d0000000 1d5000) vs hw (e0000000 10000000)
[    5.119503] radeon 0000:01:00.0: enabling device (0000 -> 0003)
[    5.122921] [drm] initializing kernel modesetting (BONAIRE 0x1002:0x6640 0x1028:0x05CD).
[    5.127194] [drm] register mmio base: 0xF7C00000
[    5.130223] [drm] register mmio size: 262144
[    5.133151] [drm] doorbell mmio base: 0xF0000000
[    5.136196] [drm] doorbell mmio size: 8388608
[    5.211621] random: nonblocking pool is initialized
[    5.680867] ATOM BIOS: Dell
[    5.683840] [drm] GPU not posted. posting now...
[    5.691017] radeon 0000:01:00.0: VRAM: 2048M 0x0000000000000000 - 0x000000007FFFFFFF (2048M used)
[    5.695829] radeon 0000:01:00.0: GTT: 1024M 0x0000000080000000 - 0x00000000BFFFFFFF
[    5.700350] [drm] Detected VRAM RAM=2048M, BAR=256M
[    5.703527] [drm] RAM width 128bits DDR
[    5.706543] [TTM] Zone  kernel: Available graphics memory: 16458720 kiB
[    5.710144] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    5.714196] [TTM] Initializing pool allocator
[    5.717144] [TTM] Initializing DMA pool allocator
[    5.720241] [drm] radeon: 2048M of VRAM memory ready
[    5.723425] [drm] radeon: 1024M of GTT memory ready.
[    5.726618] [drm] Loading bonaire Microcode
[    5.729828] [drm] Internal thermal controller without fan control
[    5.733198] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
[    5.737172] == power state 0 ==
[    5.738725]  ui class: none
[    5.740705]  internal class: boot 
[    5.743341]  caps: 
[    5.743341]  uvd    vclk: 0 dclk: 0
[    5.743342]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[    5.743342]  status: c r b 
[    5.743343] == power state 1 ==
[    5.743343]  ui class: performance
[    5.743343]  internal class: none
[    5.743343]  caps: 
[    5.743344]  uvd    vclk: 0 dclk: 0
[    5.743354]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[    5.743357]          power level 1    sclk: 107500 mclk: 137500 pcie gen: 3 pcie lanes: 16
[    5.743357]  status: 
[    5.743357] == power state 2 ==
[    5.743358]  ui class: battery
[    5.743358]  internal class: none
[    5.743358]  caps: 
[    5.743358]  uvd    vclk: 0 dclk: 0
[    5.743359]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[    5.743360]          power level 1    sclk: 60000 mclk: 30000 pcie gen: 3 pcie lanes: 16
[    5.743360]  status: 
[    5.751286] [drm] radeon: dpm initialized
[    5.753470] [drm] Found VCE firmware/feedback version 40.2.2 / 15!
[    5.753498] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    5.753958] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
[    5.753960] [drm] PCIE gen 3 link speeds already enabled
[    5.755161] [drm] PCIE GART of 1024M enabled (table at 0x000000000078C000).
[    5.755257] radeon 0000:01:00.0: WB enabled
[    5.755260] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff880801ccdc00
[    5.755261] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff880801ccdc04
[    5.755262] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff880801ccdc08
[    5.755262] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff880801ccdc0c
[    5.755263] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff880801ccdc10
[    5.755633] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000076c98 and cpu addr 0xffffc90009f36c98
[    5.755672] radeon 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0000000080000c18 and cpu addr 0xffff880801ccdc18
[    5.755672] radeon 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0000000080000c1c and cpu addr 0xffff880801ccdc1c
[    5.755673] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    5.755673] [drm] Driver supports precise vblank timestamp query.
[    5.755691] radeon 0000:01:00.0: irq 30 for MSI/MSI-X
[    5.755698] radeon 0000:01:00.0: radeon: using MSI.
[    5.755721] [drm] radeon: irq initialized.
[    5.758206] [drm] ring test on 0 succeeded in 2 usecs
[    5.758286] [drm] ring test on 1 succeeded in 2 usecs
[    5.758300] [drm] ring test on 2 succeeded in 2 usecs
[    5.758420] [drm] ring test on 3 succeeded in 3 usecs
[    5.758425] [drm] ring test on 4 succeeded in 4 usecs
[    5.794471] [drm] ring test on 5 succeeded in 1 usecs
[    5.814487] [drm] UVD initialized successfully.
[    5.924581] [drm] ring test on 6 succeeded in 23 usecs
[    5.926695] [drm] ring test on 7 succeeded in 4 usecs
[    5.928777] [drm] VCE initialized successfully.
[    5.932283] [drm] ib test on ring 0 succeeded in 0 usecs
[    6.435615] [drm] ib test on ring 1 succeeded in 0 usecs
[    6.939729] [drm] ib test on ring 2 succeeded in 0 usecs
[    6.943099] [drm] ib test on ring 3 succeeded in 0 usecs
[    6.946417] [drm] ib test on ring 4 succeeded in 0 usecs
[    7.470848] [drm] ib test on ring 5 succeeded
[    7.494834] [drm] ib test on ring 6 succeeded
[    7.498572] [drm] ib test on ring 7 succeeded
[    7.501609] [drm] Radeon Display Connectors
[    7.503649] [drm] Connector 0:
[    7.506081] [drm]   DP-1
[    7.507320] [drm]   HPD1
[    7.509303] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
[    7.513696] [drm]   Encoders:
[    7.515129] [drm]     DFP1: INTERNAL_UNIPHY1
[    7.517773] [drm] Connector 1:
[    7.519204] [drm]   DP-2
[    7.520428] [drm]   HPD2
[    7.522414] [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 0x6548 0x6548 0x654c 0x654c
[    7.527080] [drm]   Encoders:
[    7.528100] [drm]     DFP2: INTERNAL_UNIPHY1
[    7.530457] [drm] Connector 2:
[    7.532305] [drm]   DP-3
[    7.533575] [drm]   HPD3
[    7.534454] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
[    7.537835] [drm]   Encoders:
[    7.538831] [drm]     DFP3: INTERNAL_UNIPHY2
[    7.540568] [drm] Connector 3:
[    7.542383] [drm]   VGA-1
[    7.543682] [drm]   DDC: 0x65c0 0x65c0 0x65c4 0x65c4 0x65c8 0x65c8 0x65cc 0x65cc
[    7.546438] [drm]   Encoders:
[    7.548037] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    7.550574] switching from power state:
[    7.552093]  ui class: none
[    7.553510]  internal class: boot 
[    7.554679]  caps: 
[    7.555765]  uvd    vclk: 0 dclk: 0
[    7.557520]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[    7.560307]  status: c b 
[    7.561949] switching to power state:
[    7.563628]  ui class: performance
[    7.564750]  internal class: none
[    7.566226]  caps: 
[    7.567591]  uvd    vclk: 0 dclk: 0
[    7.568727]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[    7.572274]          power level 1    sclk: 107500 mclk: 137500 pcie gen: 3 pcie lanes: 16
[    7.575800]  status: r 
[    7.599135] radeon 0000:01:00.0: No connectors reported connected with modes
[    7.602891] [drm] Cannot find any crtc or sizes - going 1024x768
[    7.605821] [drm] fb mappable at 0xE098F000
[    7.607409] [drm] vram apper at 0xE0000000
[    7.609077] [drm] size 3145728
[    7.610769] [drm] fb depth is 24
[    7.612422] [drm]    pitch is 4096
[    7.613564] checking generic (d0000000 1d5000) vs hw (e0000000 10000000)
[    7.613669] radeon 0000:01:00.0: fb1: radeondrmfb frame buffer device
[    7.616753] radeon 0000:01:00.0: registered panic notifier
[    7.629079] [drm] Initialized radeon 2.40.0 20080528 for 0000:01:00.0 on minor 0
[    7.642941] PM: Starting manual resume from disk
[    7.644818] PM: Hibernation image partition 8:5 present
[    7.644819] PM: Looking for hibernation image.
[    7.645021] PM: Image not found (code -22)
[    7.645023] PM: Hibernation image not present or could not be loaded.
[    7.670305] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    8.034115] systemd-journald[256]: Received SIGTERM from PID 1 (systemd).
[    8.610748] SELinux:  Disabled at runtime.
[    8.613794] SELinux:  Unregistering netfilter hooks
[    8.640029] audit: type=1404 audit(1418687411.985:2): selinux=0 auid=4294967295 ses=4294967295
[    9.582244] systemd-readahead[440]: Bumped block_nr parameter of 8:0 to 20480. This is a temporary hack and should be removed one day.
[   10.774649] EXT4-fs (sda2): re-mounted. Opts: (null)
[   11.149764] systemd-journald[445]: Received request to flush runtime journal from PID 1
[   14.898407] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140926/utaddress-258)
[   14.907693] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.575058] wmi: Mapper loaded
[   15.777314] EDAC MC: Ver: 3.0.0
[   15.853194] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   16.071039] mei_me 0000:00:16.0: irq 31 for MSI/MSI-X
[   16.085057] EDAC ie31200: No ECC support
[   16.124343] input: PC Speaker as /devices/platform/pcspkr/input/input10
[   16.335830] parport_pc 00:07: [io  0x0378-0x037b]
[   16.335855] parport_pc 00:07: [io  0x0278-0x027b]
[   16.335876] parport_pc 00:07: [io  0x03bc-0x03bf]
[   16.335897] parport_pc 00:07: [io  0x0378-0x037b]
[   16.335939] parport_pc 00:07: [irq 7]
[   16.404788] parport_pc 00:07: activated
[   16.407543] parport_pc 00:07: reported by Plug and Play ACPI
[   16.411048] parport_pc 00:07: disabled
[   16.497931] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   16.778945] sdhci-pci 0000:11:00.0: SDHCI controller found [1217:8520] (rev 1)
[   16.783440] mmc0: Unknown controller version (3). You may experience problems.
[   16.787391] sdhci-pci 0000:11:00.0: No vmmc regulator found
[   16.791034] sdhci-pci 0000:11:00.0: No vqmmc regulator found
[   16.797591] mmc0: SDHCI controller on PCI [0000:11:00.0] using ADMA
[   16.876133] iTCO_vendor_support: vendor-support=0
[   16.902023] alg: No test for crc32 (crc32-pclmul)
[   17.095667] input: Dell WMI hotkeys as /devices/virtual/input/input11
[   17.428307] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   17.431599] iTCO_wdt: Found a Lynx Point TCO device (Version=2, TCOBASE=0x1860)
[   17.436069] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   17.481349] Adding 32502780k swap on /dev/sda5.  Priority:-1 extents:1 across:32502780k FS
[   17.543347] media: Linux media interface: v0.10
[   17.727791] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   17.909303] ppdev: user-space parallel port driver
[   18.109849] cfg80211: Calling CRDA to update world regulatory domain
[   18.446530] Linux video capture interface: v2.00
[   18.798869] cfg80211: World regulatory domain updated:
[   18.803262] cfg80211:  DFS Master region: unset
[   18.804982] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   18.811997] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   18.815866] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   18.819512] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[   18.824158] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[   18.828840] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   18.833506] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   18.838171] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[   18.842542] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   19.313908] uvcvideo: Found UVC 1.00 device <unnamed> (046d:0990)
[   19.334230] input: UVC Camera (046d:0990) as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/input/input12
[   19.339208] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_HD (0c45:64d0)
[   19.382568] input: Laptop_Integrated_Webcam_HD as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.5/3-1.5:1.0/input/input13
[   19.388428] usbcore: registered new interface driver uvcvideo
[   19.391481] USB Video Class driver (1.1.1)
[   19.847333] usb 1-2: Warning! Unlikely big volume range (=3072), cval->res is probably wrong.
[   19.853005] usb 1-2: [5] FU [Mic Capture Volume] ch = 1, val = 4608/7680/1
[   19.857279] usbcore: registered new interface driver snd-usb-audio
[   19.862801] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[   19.864722] EXT4-fs (sda4): mounted filesystem without journal. Opts: (null)
[   19.870386] Copyright(c) 2003- 2014 Intel Corporation
[   19.870421] iwlwifi 0000:03:00.0: enabling device (0000 -> 0002)
[   19.870532] iwlwifi 0000:03:00.0: irq 32 for MSI/MSI-X
[   19.982899] Bluetooth: Core ver 2.19
[   19.984213] NET: Registered protocol family 31
[   19.986193] Bluetooth: HCI device and connection manager initialized
[   19.989444] Bluetooth: HCI socket layer initialized
[   19.991541] Bluetooth: L2CAP socket layer initialized
[   19.993684] Bluetooth: SCO socket layer initialized
[   20.434308] iwlwifi 0000:03:00.0: Direct firmware load for iwlwifi-7260-10.ucode failed with error -2
[   20.626911] [drm] Memory usable by graphics device = 2048M
[   20.630659] [drm] VT-d active for gfx access
[   20.633547] checking generic (d0000000 1d5000) vs hw (d0000000 10000000)
[   20.633548] fb: switching to inteldrmfb from EFI VGA
[   20.637022] Console: switching to colour dummy device 80x25
[   20.640099] [drm] Replacing VGA console driver
[   20.657763] i915 0000:00:02.0: irq 33 for MSI/MSI-X
[   20.657769] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   20.660839] [drm] Driver supports precise vblank timestamp query.
[   20.663748] vga_switcheroo: enabled
[   20.665159] ATPX version 1, functions 0x00000033
[   20.667176] [drm] DMAR active, disabling use of stolen memory
[   20.669959] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
[   20.674035] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   20.697709] usbcore: registered new interface driver btusb
[   20.709393] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[   20.713807] ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: no)
[   20.717356] Bluetooth: hci0: read Intel version: 370710018002030d41
[   20.717392] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:50/LNXVIDEO:00/input/input14
[   20.718160] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   20.728879] Bluetooth: hci0: Intel device is already patched. patch num: 41
[   20.741775] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input15
[   20.745882] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 1
[   20.749638] fbcon: inteldrmfb (fb0) is primary device
[   20.768963] iwlwifi 0000:03:00.0: loaded firmware version 25.222.9.0 op_mode iwlmvm
[   20.783635] snd_hda_intel 0000:00:03.0: enabling device (0000 -> 0002)
[   20.783804] snd_hda_intel 0000:00:1b.0: irq 34 for MSI/MSI-X
[   20.783911] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[   20.783914] snd_hda_intel 0000:01:00.1: VGA controller is disabled
[   20.783914] snd_hda_intel 0000:01:00.1: Delaying initialization
[   20.785722] snd_hda_intel 0000:00:03.0: irq 35 for MSI/MSI-X
[   20.798841] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card1/input16
[   20.798881] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card1/input17
[   20.798914] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card1/input18
[   20.800208] sound hdaudioC2D0: autoconfig: line_outs=1 (0x16/0x0/0x0/0x0/0x0) type:line
[   20.800209] sound hdaudioC2D0:    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
[   20.800210] sound hdaudioC2D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[   20.800210] sound hdaudioC2D0:    mono: mono_out=0x0
[   20.800211] sound hdaudioC2D0:    inputs:
[   20.800212] sound hdaudioC2D0:      Front Mic=0x18
[   20.800212] sound hdaudioC2D0:      Dock Mic=0x19
[   20.800213] sound hdaudioC2D0:      Headset Mic=0x1a
[   20.800213] sound hdaudioC2D0:      Internal Mic=0x12
[   20.805683] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card2/input19
[   20.805724] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card2/input20
[   20.805756] input: HDA Intel PCH Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card2/input21
[   20.805784] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card2/input22
[   21.526462] Console: switching to colour frame buffer device 240x67
[   21.600718] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   22.907060] iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
[   22.911852] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
[   22.915702] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
[   22.932137] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[   22.935693] iwlwifi 0000:03:00.0 wlp3s0: renamed from wlan0
[   23.252409] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   23.252410] Bluetooth: BNEP filters: protocol multicast
[   23.252415] Bluetooth: BNEP socket layer initialized
[   23.446488] [drm:ci_dpm_enable [radeon]] *ERROR* ci_start_dpm failed
[   23.449726] [drm:radeon_pm_resume [radeon]] *ERROR* radeon: dpm resume failed
[   23.454002] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
[   23.457707] [drm] PCIE gen 3 link speeds already enabled
[   23.462948] [drm] PCIE GART of 1024M enabled (table at 0x000000000FE00000).
[   23.467348] radeon 0000:01:00.0: WB enabled
[   23.470190] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff880801ccdc00
[   23.475917] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff880801ccdc04
[   23.475918] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff880801ccdc08
[   23.475920] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff880801ccdc0c
[   23.475921] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff880801ccdc10
[   23.476310] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000076c98 and cpu addr 0xffffc90009f36c98
[   23.476364] radeon 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0000000080000c18 and cpu addr 0xffff880801ccdc18
[   23.476365] radeon 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0000000080000c1c and cpu addr 0xffff880801ccdc1c
[   23.478391] [drm] ring test on 0 succeeded in 2 usecs
[   23.552760] cfg80211: Calling CRDA for country: CA
[   23.639403] [drm:cik_ring_test [radeon]] *ERROR* radeon: ring 1 test failed (scratch(0x3010C)=0xCAFEDEAD)
[   23.933278] [drm:cik_ring_test [radeon]] *ERROR* radeon: ring 2 test failed (scratch(0x3010C)=0xCAFEDEAD)
[   23.938237] [drm] ring test on 3 succeeded in 4 usecs
[   23.938562] cfg80211: Regulatory domain changed to country: CA
[   23.938564] cfg80211:  DFS Master region: FCC
[   23.938564] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   23.938565] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 3000 mBm), (N/A)
[   23.938566] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 1700 mBm), (N/A)
[   23.938567] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2400 mBm), (0 s)
[   23.938568] cfg80211:   (5490000 KHz - 5730000 KHz @ 80000 KHz), (N/A, 2400 mBm), (0 s)
[   23.938568] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 3000 mBm), (N/A)
[   24.079283] [drm:cik_sdma_ring_test [radeon]] *ERROR* radeon: ring 4 test failed (0xCAFEDEAD)
[   24.082985] [drm:cik_resume [radeon]] *ERROR* cik startup failed on resume
[   24.085613] [drm] ib test on ring 0 succeeded in 0 usecs
[   24.087814] [drm] ib test on ring 3 succeeded in 0 usecs
[   34.111661] radeon 0000:01:00.0: ring 6 stalled for more than 10020msec
[   34.116819] radeon 0000:01:00.0: GPU lockup (current fence id 0x0000000000000002 last fence id 0x0000000000000004 on ring 6)
[   34.125175] [drm:radeon_vce_ib_test [radeon]] *ERROR* radeon: fence wait failed (-35).
[   34.131433] [drm:radeon_ib_ring_tests [radeon]] *ERROR* radeon: failed testing IB on ring 6 (-35).
[   44.159798] radeon 0000:01:00.0: ring 7 stalled for more than 10020msec
[   44.166237] radeon 0000:01:00.0: GPU lockup (current fence id 0x0000000000000002 last fence id 0x0000000000000004 on ring 7)
[   44.174367] [drm:radeon_vce_ib_test [radeon]] *ERROR* radeon: fence wait failed (-35).
[   44.180562] [drm:radeon_ib_ring_tests [radeon]] *ERROR* radeon: failed testing IB on ring 7 (-35).
[   44.187644] [drm:radeon_pm_resume [radeon]] *ERROR* radeon: dpm resume failed
[   44.321596] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   44.421838] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   44.611178] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   44.630120] tun: Universal TUN/TAP device driver, 1.6
[   44.632864] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   44.677097] device virbr0-nic entered promiscuous mode
[   44.689067] virbr0: port 1(virbr0-nic) entered forwarding state
[   44.691867] virbr0: port 1(virbr0-nic) entered forwarding state
[   44.815950] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   44.877071] virbr0: port 1(virbr0-nic) entered disabled state
[   47.024973] e1000e: eno1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   58.385523] Bluetooth: RFCOMM TTY layer initialized
[   58.388822] Bluetooth: RFCOMM socket layer initialized
[   58.391081] Bluetooth: RFCOMM ver 1.11
[   76.378407] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
[   76.381614] [drm] PCIE gen 3 link speeds already enabled
[   76.385811] [drm] PCIE GART of 1024M enabled (table at 0x000000000078C000).
[   76.389306] radeon 0000:01:00.0: WB enabled
[   76.391080] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff880801ccdc00
[   76.395816] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff880801ccdc04
[   76.400814] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff880801ccdc08
[   76.405535] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff880801ccdc0c
[   76.410310] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff880801ccdc10
[   76.410713] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000076c98 and cpu addr 0xffffc90009f36c98
[   76.410756] radeon 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0000000080000c18 and cpu addr 0xffff880801ccdc18
[   76.410757] radeon 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0000000080000c1c and cpu addr 0xffff880801ccdc1c
[   76.412797] [drm] ring test on 0 succeeded in 2 usecs
[   76.412876] [drm] ring test on 1 succeeded in 2 usecs
[   76.412888] [drm] ring test on 2 succeeded in 1 usecs
[   76.413000] [drm] ring test on 3 succeeded in 4 usecs
[   76.413005] [drm] ring test on 4 succeeded in 2 usecs
[   76.449090] [drm] ring test on 5 succeeded in 2 usecs
[   76.471373] [drm] UVD initialized successfully.
[   76.583402] [drm] ring test on 6 succeeded in 11 usecs
[   76.586207] [drm] ring test on 7 succeeded in 3 usecs
[   76.588434] [drm] VCE initialized successfully.
[   76.590482] [drm] ib test on ring 0 succeeded in 0 usecs
[   77.093466] [drm] ib test on ring 1 succeeded in 0 usecs
[   77.598529] [drm] ib test on ring 2 succeeded in 0 usecs
[   77.601328] [drm] ib test on ring 3 succeeded in 0 usecs
[   77.603668] [drm] ib test on ring 4 succeeded in 0 usecs
[   78.126660] [drm] ib test on ring 5 succeeded
[   78.150054] [drm] ib test on ring 6 succeeded
[   78.153828] [drm] ib test on ring 7 succeeded
[   78.159323] switching from power state:
[   78.161801]  ui class: none
[   78.163145]  internal class: boot 
[   78.164500]  caps: 
[   78.165575]  uvd    vclk: 0 dclk: 0
[   78.167137]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[   78.170408]  status: c b 
[   78.171588] switching to power state:
[   78.173287]  ui class: battery
[   78.174467]  internal class: none
[   78.176055]  caps: 
[   78.177105]  uvd    vclk: 0 dclk: 0
[   78.178485]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[   78.181900]          power level 1    sclk: 60000 mclk: 30000 pcie gen: 3 pcie lanes: 16
[   78.185360]  status: r 
[   78.191344] snd_hda_intel 0000:01:00.1: Start delayed initialization
[   78.195309] snd_hda_intel 0000:01:00.1: irq 36 for MSI/MSI-X
[   78.298530] snd_hda_intel 0000:01:00.1: CORB reset timeout#2, CORBRP = 65535
[   78.300524] snd_hda_intel 0000:01:00.1: no AFG or MFG node found                                                                                                              
[   78.303813] snd_hda_intel 0000:01:00.1: no AFG or MFG node found                                                                                                              
[   78.306054] snd_hda_intel 0000:01:00.1: no AFG or MFG node found                                                                                                              
[   78.308797] snd_hda_intel 0000:01:00.1: no AFG or MFG node found                                                                                                              
[   78.311717] snd_hda_intel 0000:01:00.1: no codecs initialized                                                                                                                 
[   78.314116] snd_hda_intel 0000:01:00.1: initialization error                                                                                                                  
[  180.649276] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
[  180.653870] [drm] PCIE gen 3 link speeds already enabled
[  180.658984] [drm] PCIE GART of 1024M enabled (table at 0x000000000FE00000).
[  180.662513] radeon 0000:01:00.0: WB enabled
[  180.664324] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff880801ccdc00
[  180.669216] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff880801ccdc04
[  180.673776] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff880801ccdc08
[  180.678779] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff880801ccdc0c
[  180.683522] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff880801ccdc10
[  180.688891] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000076c98 and cpu addr 0xffffc90009f36c98
[  180.694291] radeon 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0000000080000c18 and cpu addr 0xffff880801ccdc18
[  180.699235] radeon 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0000000080000c1c and cpu addr 0xffff880801ccdc1c
[  180.705942] [drm] ring test on 0 succeeded in 4 usecs
[  180.708284] [drm] ring test on 1 succeeded in 3 usecs
[  180.710450] [drm] ring test on 2 succeeded in 2 usecs
[  180.712758] [drm] ring test on 3 succeeded in 4 usecs
[  180.715147] [drm] ring test on 4 succeeded in 4 usecs
[  180.753481] [drm] ring test on 5 succeeded in 2 usecs
[  180.775326] [drm] UVD initialized successfully.
[  180.887565] [drm] ring test on 6 succeeded in 11 usecs
[  180.890366] [drm] ring test on 7 succeeded in 3 usecs
[  180.892558] [drm] VCE initialized successfully.
[  180.894661] [drm] ib test on ring 0 succeeded in 0 usecs
[  180.896949] [drm] ib test on ring 1 succeeded in 0 usecs
[  180.899559] [drm] ib test on ring 2 succeeded in 0 usecs
[  180.901913] [drm] ib test on ring 3 succeeded in 0 usecs
[  180.904249] [drm] ib test on ring 4 succeeded in 0 usecs
[  181.428243] [drm] ib test on ring 5 succeeded
[  181.451660] [drm] ib test on ring 6 succeeded
[  181.455243] [drm] ib test on ring 7 succeeded
[  181.460913] switching from power state:
[  181.463232]  ui class: none
[  181.464585]  internal class: boot 
[  181.465928]  caps: 
[  181.467025]  uvd    vclk: 0 dclk: 0
[  181.468605]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[  181.471783]  status: c b 
[  181.473062] switching to power state:
[  181.474752]  ui class: battery
[  181.475953]  internal class: none
[  181.477492]  caps: 
[  181.478571]  uvd    vclk: 0 dclk: 0
[  181.479916]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[  181.483366]          power level 1    sclk: 60000 mclk: 30000 pcie gen: 3 pcie lanes: 16
[  181.487660]  status: r 
[  209.392519] snd_hda_intel 0000:00:1b.0: IRQ timing workaround is activated for card #2. Suggest a bigger bdl_pos_adj.
[  239.732018] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
[  239.735342] [drm] PCIE gen 3 link speeds already enabled
[  239.739603] [drm] PCIE GART of 1024M enabled (table at 0x000000000078C000).
[  239.743005] radeon 0000:01:00.0: WB enabled
[  239.744803] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff880801ccdc00
[  239.749539] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff880801ccdc04
[  239.754528] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff880801ccdc08
[  239.759259] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff880801ccdc0c
[  239.764273] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff880801ccdc10
[  239.769418] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000076c98 and cpu addr 0xffffc90009f36c98
[  239.774753] radeon 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0000000080000c18 and cpu addr 0xffff880801ccdc18
[  239.779713] radeon 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0000000080000c1c and cpu addr 0xffff880801ccdc1c
[  239.786426] [drm] ring test on 0 succeeded in 4 usecs
[  239.788734] [drm] ring test on 1 succeeded in 3 usecs
[  239.791175] [drm] ring test on 2 succeeded in 2 usecs
[  239.793510] [drm] ring test on 3 succeeded in 4 usecs
[  239.795637] [drm] ring test on 4 succeeded in 1 usecs
[  239.843928] [drm] ring test on 5 succeeded in 2 usecs
[  239.866959] [drm] UVD initialized successfully.
[  239.979966] [drm] ring test on 6 succeeded in 13 usecs
[  239.982779] [drm] ring test on 7 succeeded in 3 usecs
[  239.984990] [drm] VCE initialized successfully.
[  239.987074] [drm] ib test on ring 0 succeeded in 0 usecs
[  240.490411] [drm] ib test on ring 1 succeeded in 0 usecs
[  240.993583] [drm] ib test on ring 2 succeeded in 0 usecs
[  240.995790] [drm] ib test on ring 3 succeeded in 0 usecs
[  240.998085] [drm] ib test on ring 4 succeeded in 0 usecs
[  241.521685] [drm] ib test on ring 5 succeeded
[  241.545585] [drm] ib test on ring 6 succeeded
[  241.549273] [drm] ib test on ring 7 succeeded
[  241.555262] switching from power state:
[  241.557210]  ui class: none
[  241.558579]  internal class: boot 
[  241.560133]  caps: 
[  241.560944]  uvd    vclk: 0 dclk: 0
[  241.562569]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[  241.567981]  status: c b 
[  241.568672] switching to power state:
[  241.570430]  ui class: battery
[  241.572076]  internal class: none
[  241.572945]  caps: 
[  241.574540]  uvd    vclk: 0 dclk: 0
[  241.576062]          power level 0    sclk: 30000 mclk: 15000 pcie gen: 3 pcie lanes: 16
[  241.578829]          power level 1    sclk: 60000 mclk: 30000 pcie gen: 3 pcie lanes: 16
[  241.582456]  status: r 
[  264.477548] snd_hda_intel 0000:00:1b.0: Unstable LPIB (352800 >= 176400); disabling LPIB delay counting
[  316.867816] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.871412] pci_bus 0000:02: Allocating resources
[  316.871421] pcieport 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[  316.871423] pcieport 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[  316.871424] pcieport 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
[  316.871429] pci_bus 0000:03: Allocating resources
[  316.871440] pcieport 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[  316.871442] pcieport 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[  316.871447] pci_bus 0000:04: Allocating resources
[  316.871456] pci_bus 0000:08: Allocating resources
[  316.871466] pci_bus 0000:09: Allocating resources
[  316.871475] pci_bus 0000:11: Allocating resources
[  316.871484] pcieport 0000:00:1c.7: bridge window [io  0x1000-0x0fff] to [bus 11] add_size 1000
[  316.871486] pcieport 0000:00:1c.7: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 11] add_size 200000
[  316.871487] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.875690] pcieport 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[  316.875693] pcieport 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[  316.875695] pcieport 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[  316.875699] pcieport 0000:00:1c.7: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[  316.875702] pcieport 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[  316.875704] pcieport 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[  316.875706] pcieport 0000:00:1c.7: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[  316.875710] pcieport 0000:00:1c.0: BAR 14: assigned [mem 0xcf200000-0xcf3fffff]
[  316.879028] pcieport 0000:00:1c.0: BAR 15: assigned [mem 0xcf400000-0xcf5fffff 64bit pref]
[  316.882768] pcieport 0000:00:1c.2: BAR 15: assigned [mem 0xcf600000-0xcf7fffff 64bit pref]
[  316.888480] pcieport 0000:00:1c.7: BAR 15: assigned [mem 0xcf800000-0xcf9fffff 64bit pref]
[  316.891461] pcieport 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[  316.895061] pcieport 0000:00:1c.2: BAR 13: assigned [io  0x3000-0x3fff]
[  316.897407] pcieport 0000:00:1c.7: BAR 13: assigned [io  0x4000-0x4fff]
[  316.901008] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.904791] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.907418] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.911240] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.915019] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.918510] acpi MSFT1111:00: Cannot transition to power state D3cold for parent in (unknown)
[  316.922372] acpi INT33C2:00: Cannot transition to non-D0 state from D3
[  316.924976] acpi MSFT0002:00: Cannot transition to power state D3cold for parent in (unknown)
[  316.928802] acpi ELAN1010:00: Cannot transition to power state D3cold for parent in (unknown)
[  316.932679] acpi INT33C3:00: Cannot transition to non-D0 state from D3
[  316.935371] acpi INT33C0:00: Cannot transition to non-D0 state from D3
[  316.938568] acpi INT33C1:00: Cannot transition to non-D0 state from D3
[  316.941054] acpi INT33C4:00: Cannot transition to non-D0 state from D3
[  316.944701] acpi INT33C5:00: Cannot transition to non-D0 state from D3
[  316.947020] acpi device:41: Cannot transition to power state D3cold for parent in (unknown)
[  316.950850] acpi INT33C6:00: Cannot transition to non-D0 state from D3
[  316.984861] pci_bus 0000:01: Allocating resources
[  316.984871] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.987043] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  316.990708] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  380.951588] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  380.956618] pci_bus 0000:02: Allocating resources
[  380.956630] pci_bus 0000:03: Allocating resources
[  380.956646] pci_bus 0000:04: Allocating resources
[  380.956656] pci_bus 0000:08: Allocating resources
[  380.956666] pci_bus 0000:09: Allocating resources
[  380.956676] pci_bus 0000:11: Allocating resources
[  380.956686] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  380.960377] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  380.964435] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  380.967998] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  380.972316] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  380.975816] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  380.979392] acpi MSFT1111:00: Cannot transition to power state D3cold for parent in (unknown)
[  380.983156] acpi INT33C2:00: Cannot transition to non-D0 state from D3
[  380.985981] acpi MSFT0002:00: Cannot transition to power state D3cold for parent in (unknown)
[  380.991534] acpi ELAN1010:00: Cannot transition to power state D3cold for parent in (unknown)
[  380.995216] acpi INT33C3:00: Cannot transition to non-D0 state from D3
[  380.997050] [drm] probing gen 2 caps for device 8086:c01 = 261ad03/e
[  380.997053] [drm] PCIE gen 3 link speeds already enabled
[  380.998990] [drm] PCIE GART of 1024M enabled (table at 0x000000000FE00000).
[  380.999124] radeon 0000:01:00.0: WB enabled
[  380.999127] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff880801ccdc00
[  380.999127] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff880801ccdc04
[  380.999128] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff880801ccdc08
[  380.999129] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff880801ccdc0c
[  380.999129] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff880801ccdc10
[  380.999520] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000076c98 and cpu addr 0xffffc90009f36c98
[  380.999561] radeon 0000:01:00.0: fence driver on ring 6 use gpu addr 0x0000000080000c18 and cpu addr 0xffff880801ccdc18
[  380.999562] radeon 0000:01:00.0: fence driver on ring 7 use gpu addr 0x0000000080000c1c and cpu addr 0xffff880801ccdc1c
[  381.001608] [drm] ring test on 0 succeeded in 2 usecs
[  381.001687] [drm] ring test on 1 succeeded in 2 usecs
[  381.001699] [drm] ring test on 2 succeeded in 1 usecs
[  381.001835] [drm] ring test on 3 succeeded in 0 usecs
[  381.001841] [drm] ring test on 4 succeeded in 4 usecs
[  381.037883] [drm] ring test on 5 succeeded in 1 usecs
[  381.057916] [drm] UVD initialized successfully.
[  381.062853] acpi INT33C0:00: Cannot transition to non-D0 state from D3
[  381.066256] acpi INT33C1:00: Cannot transition to non-D0 state from D3
[  381.068780] acpi INT33C4:00: Cannot transition to non-D0 state from D3
[  381.072165] acpi INT33C5:00: Cannot transition to non-D0 state from D3
[  381.074710] acpi device:41: Cannot transition to power state D3cold for parent in (unknown)
[  381.078560] acpi INT33C6:00: Cannot transition to non-D0 state from D3
[  381.081269] pci 0000:01:00.1: [1002:aac0] type 00 class 0x040300
[  381.081280] pci 0000:01:00.1: reg 0x10: [mem 0x00000000-0x00003fff 64bit]
[  381.081333] pci 0000:01:00.1: supports D1 D2
[  381.081376] pci 0000:01:00.1: System wakeup disabled by ACPI
[  381.085355] pci_bus 0000:01: Allocating resources
[  381.085364] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  381.088060] pci 0000:01:00.1: BAR 0: assigned [mem 0xf7c60000-0xf7c63fff 64bit]
[  381.091720] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[  381.095346] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[  381.097754] snd_hda_intel 0000:01:00.1: VGA controller is disabled
[  381.100294] snd_hda_intel 0000:01:00.1: Delaying initialization
[  381.103390] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  381.107099] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment



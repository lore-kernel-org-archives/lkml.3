Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbaGQXoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:44:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262AbaGQXoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:44:18 -0400
Date: Thu, 17 Jul 2014 16:44:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.49
Message-ID: <20140717234417.GA16847@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.49 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arm64/include/asm/memory.h              |    2=20
 arch/parisc/kernel/hardware.c                |    3=20
 arch/powerpc/include/asm/perf_event_server.h |    2=20
 arch/powerpc/perf/core-book3s.c              |   22 ++
 arch/powerpc/perf/power8-pmu.c               |    2=20
 arch/score/Kconfig                           |    3=20
 arch/score/Makefile                          |    4=20
 arch/score/include/asm/checksum.h            |   93 +++++----
 arch/score/include/asm/io.h                  |    1=20
 arch/score/include/asm/pgalloc.h             |    2=20
 arch/score/kernel/entry.S                    |    4=20
 arch/score/kernel/process.c                  |    4=20
 arch/score/kernel/vmlinux.lds.S              |    1=20
 arch/x86/crypto/sha512_ssse3_glue.c          |    2=20
 arch/x86/mm/ioremap.c                        |   26 ++
 drivers/acpi/battery.c                       |   27 ++
 drivers/acpi/resource.c                      |   10 -
 drivers/clk/spear/spear3xx_clock.c           |    2=20
 drivers/cpufreq/Makefile                     |    2=20
 drivers/gpu/drm/radeon/evergreen.c           |    8=20
 drivers/gpu/drm/radeon/rs600.c               |    6=20
 drivers/hv/connection.c                      |    8=20
 drivers/hwmon/adm1021.c                      |   14 -
 drivers/hwmon/adm1029.c                      |    3=20
 drivers/hwmon/adm1031.c                      |    8=20
 drivers/hwmon/amc6821.c                      |    2=20
 drivers/md/dm-io.c                           |   22 --
 drivers/usb/serial/cp210x.c                  |    1=20
 drivers/usb/serial/ftdi_sio.c                |    5=20
 drivers/usb/serial/ftdi_sio_ids.h            |    9=20
 drivers/usb/serial/option.c                  |    2=20
 fs/ext4/ialloc.c                             |   14 -
 fs/ext4/super.c                              |    9=20
 fs/jbd2/transaction.c                        |    5=20
 include/linux/ring_buffer.h                  |    2=20
 kernel/cpuset.c                              |    8=20
 kernel/rtmutex-debug.h                       |    5=20
 kernel/rtmutex.c                             |  252 ++++++++++++++++++++++=
+----
 kernel/rtmutex.h                             |    5=20
 kernel/trace/ring_buffer.c                   |    5=20
 kernel/trace/trace.c                         |   25 +-
 kernel/trace/trace.h                         |    4=20
 kernel/workqueue.c                           |    3=20
 mm/mempolicy.c                               |    2=20
 45 files changed, 478 insertions(+), 163 deletions(-)

Alex Deucher (1):
      drm/radeon: fix typo in golden register setup on evergreen

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Andy Whitcroft (1):
      ACPI / resources: only reject zero length resources based at address =
zero

Anton Blanchard (1):
      powerpc/perf: Never program book3s PMCs with values >=3D 0x80000000

Axel Lin (3):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
      hwmon: (adm1021) Fix cache problem when writing temperature limits

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Christian K=F6nig (1):
      drm/radeon: stop poisoning the GART TLB

Colin Cross (1):
      arm64: implement TASK_SIZE_OF

Eric Sandeen (1):
      ext4: disable synchronous transaction batching if max_batch_time=3D=
=3D0

Greg Kroah-Hartman (1):
      Linux 3.10.49

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Guenter Roeck (1):
      hwmon: (adm1031) Fix writes to limit registers

Helge Deller (1):
      parisc: add serial ports of C8000/1GHz machine to hardware database

Jiang Liu (1):
      score: normalize global variables exported by vmlinux.lds

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io

Joel Stanley (2):
      powerpc/perf: Add PPMU_ARCH_207S define
      powerpc/perf: Clear MMCR2 when enabling PMU

Jussi Kivilinna (1):
      crypto: sha512_ssse3 - fix byte count to bit count conversion

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code

Lan Tianyu (1):
      ACPI / battery: Retry to get battery information if failed during pro=
bing

Lennox Wu (3):
      Score: Implement the function csum_ipv6_magic
      Score: The commit is for compiling successfully.
      Score: Modify the Makefile of Score, remove -mlong-calls for compiling

Maxime Bizon (1):
      workqueue: fix dev_set_uevent_suppress() imbalance

Michal Sojka (1):
      USB: serial: ftdi_sio: Add Infineon Triboard

Prabhakar Lad (1):
      cpufreq: Makefile: fix compilation for davinci platform

Roland Dreier (1):
      x86, ioremap: Speed up check for RAM pages

Steven Rostedt (Red Hat) (1):
      ring-buffer: Check if buffer exists before polling

Theodore Ts'o (2):
      ext4: fix unjournalled bg descriptor while initializing inode bitmap
      ext4: clarify error count warning messages

Thomas Gleixner (5):
      clk: spear3xx: Use proper control register offset
      rtmutex: Fix deadlock detector for real
      rtmutex: Detect changes in the pi lock chain
      rtmutex: Handle deadlock detection smarter
      rtmutex: Plug slow unlock race

Yasuaki Ishimatsu (1):
      workqueue: zero cpumask of wq_numa_possible_cpumask on init


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTyF/RAAoJEDjbvchgkmk+ArcQAI/beFM8weP6Zj/Q5Vw+PLJM
c9jjEp3fQ37JZi9soiQ1mvjJAtziyPEBuzRs2wxazYMZ0VNoQRVcigxCYpY/n2yM
X52avoxmHle0obyMEeMot0Erjzb1mmho8RO7vg0ybCrHVSGJLEMwCDVugms5rYx6
Gok8ZFzmti2Ddhv7Fw+0RQx0qsofRLc2COxv3TK6ybVyvdkZppf7gB4a7CkDQ0DS
t/FozdIRZ4LxO1w7EILk2xwmoj1Dpe1PDJfjGIPsphDJUR8GjGnNst9INdXTwijF
NiM+1mEEfv9lY6dNzBQq6fkrf/altYLNa3LKNymQx3GndTt5Ae3kN2tYeSjlrvr1
4Iv2REURgFB3xhmF8Tmns4WdV6ufjzc+dwBEn2jSn1pQnTTWwo0nYV+WTOs/aVRt
h+y5BWoxqOtvQ9xuwOMhMyGKuel9CHjoyudqeO6XOlOzWlFhbLa7kMtsdzyHroqP
dI9R3FqJ9nZNlVI7j/FWYIDB2i2vgrM3tTy05Crr1HpcLhskp04l83VCmJ5IyQua
HMGnadm/IYRdfaXbAikWnpHL6Za3iodbsJiY1ycFi+cMX8k7e/u3jlO89ujU6zJ3
zzBV43ukOuGXANbDwwKhbboNlNU92oy8jvoYSbCX3nNZvqaKGrJcuNfL6+/qTHaD
D02zxib8P1B+87O4/N7p
=8nM9
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--

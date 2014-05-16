Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaEPMxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:53:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49531 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        akpm@linux-foundation.org
Date: Fri, 16 May 2014 13:47:20 +0100
Message-ID: <lsq.1400244440.390103756@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 00/34] 3.2.59-rc1 review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.59 release.
There are 34 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May 18 12:47:20 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.58 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays
         [b16c02fbfb963fa2941b7517ebf1f8a21946775e]

Ben Hutchings (1):
      rtl8192ce: Fix null dereference in watchdog
         [not upstream; fixes regression specific to 3.2]

Bjørn Mork (3):
      usb: option: add Alcatel L800MA
         [dd6b48ecec2ea7d15f28d5e5474388681899a5e1]
      usb: option: add Olivetti Olicard 500
         [533b3994610f316e5cd61b56d0c4daa15c830f89]
      usb: option: add and update a number of CMOTech devices
         [34f972d6156fe9eea2ab7bb418c71f9d1d5c8e7b]

Chris Mason (1):
      mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll
         [c98235cb8584a72e95786e17d695a8e5fafcd766]

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers
         [8a4aeec8d2d6a3edeffbdfae451cdf05cbf0fefd]

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2
         [d6de486bc22255779bd54b0fceb4c240962bf146]

David Cohen (1):
      usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM
         [01bb59ebffdec314da8da66266edf29529372f9b]

Hans de Goede (2):
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, S1 Yoga and X1
         [46a2986ebbe18757c2d8c352f8fb6e0f4f0754e3]
      xhci: For streams the css flag most be read from the stream-ctx on ep stop
         [c4bedb77ec4cb42f37cae4cbfddda8283161f7c8]

Helge Deller (1):
      parisc: fix epoll_pwait syscall on compat kernel
         [ab3e55b119c9653b19ea4edffb86f04db867ac98]

Jani Nikula (1):
      dmi: add support for exact DMI matches in addition to substring matching
         [5017b2851373ee15c7035151853bb1448800cae2]

Jeff Layton (2):
      locks: allow __break_lease to sleep even when break_time is 0
         [f1c6bb2cb8b81013e8979806f8e15e3d53efb96d]
      nfsd: set timeparms.to_maxval in setup_callback_client
         [3758cf7e14b753838fe754ede3862af10b35fdac]

Johan Hovold (3):
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
         [2e01280d2801c72878cf3a7119eac30077b463d5]
      USB: io_ti: fix firmware download on big-endian machines
         [5509076d1b4485ce9fb07705fcbcd2695907ab5b]
      USB: serial: fix sysfs-attribute removal deadlock
         [10164c2ad6d2c16809f6c09e278f946e47801b3a]

Julius Werner (1):
      usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb
         [1f81b6d22a5980955b01e08cf27fb745dc9b686f]

Kazuya Mio (1):
      ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS
         [4adb6ab3e0fa71363a5ef229544b2d17de6600d7]

Larry Finger (1):
      staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0
         [f764cd68d9036498f08fe8834deb6a367b5c2542]

Linus Torvalds (1):
      mm: make fixup_user_fault() check the vma access rights too
         [1b17844b29ae042576bea588164f2f1e9590a8bc]

Masayoshi Mizuma (1):
      mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()
         [7848a4bf51b34f41fcc9bd77e837126d99ae84e3]

Matthew Daley (2):
      [1/2] floppy: ignore kernel-only members in FDRAWCMD ioctl input
         [ef87dbe7614341c2e7bfe8d32fcb7028cc97442c]
      [2/2] floppy: don't write kernel-only members to FDRAWCMD ioctl  output
         [2145e15e0557a01b9195d1c7199a1b92cb9be81f]

Matthew Wilcox (1):
      ext4: note the error in ext4_end_bio()
         [9503c67c93ed0b95ba62d12d1fd09da6245dbdd6]

Miao Xie (1):
      Btrfs: fix inode caching vs tree log
         [1c70d8fb4dfa95bee491816b2a6767b5ca1080e7]

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver
         [895d240d1db0b2736d779200788e4c4aea28a0c6]

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards
         [efe26e16b1d93ac0085e69178cc18811629e8fc5]

Peter Hurley (1):
      n_tty: Fix n_tty_write crash when echoing in raw mode
         [4291086b1f081b869c6d79e5b7441633dc3ace00]

Stefan Behrens (1):
      Btrfs: Don't allocate inode that is already in use
         [ff76b0565523319d7c1c0b51d5a5a8915d33efab]

Theodore Ts'o (1):
      ext4: use i_size_read in ext4_unaligned_aio()
         [6e6358fc3c3c862bfe9a5bc029d3f8ce43dc9765]

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)
         [72b3007951010ce1bbf950e23b19d9839fa905a5]

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems
         [80bb3ef109ff40a7593d9481c17de9bbc4d7c0e2]

 Makefile                                          |  4 +-
 arch/arm/include/asm/div64.h                      |  2 +-
 arch/parisc/kernel/syscall_table.S                |  2 +-
 drivers/ata/libata-core.c                         | 21 +++---
 drivers/block/floppy.c                            | 11 +--
 drivers/firmware/dmi_scan.c                       | 12 +++-
 drivers/input/mouse/synaptics.c                   | 42 ++++++++++++
 drivers/net/ethernet/mellanox/mlx4/en_cq.c        |  1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |  6 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h      |  1 -
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |  3 +
 drivers/staging/rtl8712/rtl871x_recv.c            | 13 ++--
 drivers/tty/n_tty.c                               |  2 +
 drivers/usb/class/cdc-acm.c                       | 28 ++++++--
 drivers/usb/host/xhci-ring.c                      | 76 +++++++++++----------
 drivers/usb/host/xhci.c                           |  7 +-
 drivers/usb/host/xhci.h                           |  2 -
 drivers/usb/serial/cp210x.c                       |  1 +
 drivers/usb/serial/ftdi_sio.c                     | 33 +++++++++
 drivers/usb/serial/ftdi_sio_ids.h                 | 37 ++++++++++
 drivers/usb/serial/io_ti.c                        | 50 +++++++++-----
 drivers/usb/serial/option.c                       | 83 +++++++++++++++++++++--
 drivers/usb/serial/pl2303.c                       |  3 +
 drivers/usb/serial/pl2303.h                       |  5 +-
 drivers/usb/serial/sierra.c                       |  1 -
 drivers/usb/serial/usb-serial.c                   |  4 +-
 fs/btrfs/inode-map.c                              | 18 +----
 fs/ext4/file.c                                    |  2 +-
 fs/ext4/inode.c                                   |  5 ++
 fs/ext4/page-io.c                                 |  5 +-
 fs/locks.c                                        |  7 +-
 fs/nfsd/nfs4callback.c                            |  4 +-
 include/linux/libata.h                            |  1 +
 include/linux/mod_devicetable.h                   |  6 +-
 mm/hugetlb.c                                      |  1 +
 mm/memory.c                                       |  5 ++
 36 files changed, 372 insertions(+), 132 deletions(-)

-- 
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.


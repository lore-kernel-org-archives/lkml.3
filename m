Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaGHADP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:03:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaGHADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/44] 3.4.98-stable review
Date: Mon,  7 Jul 2014 17:06:50 -0700
Message-Id: <20140707235858.652771077@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.98 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jul  9 23:58:50 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.98-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.98-rc1

Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
    powerpc/sysfs: Disable writing to PURR in guest mode

Gustavo Maciel Dias Vieira <gustavo@sagui.org>
    ACPI video: ignore BIOS backlight value for HP dm4

Anton Blanchard <anton@samba.org>
    powerpc/pseries: Duplicate dtl entries sometimes sent to userspace

Chen Gang <gang.chen@asianux.com>
    powerpc/pseries/lparcfg: Fix possible overflow are more than 1026

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    powerpc: Restore registers on error exit from csum_partial_copy_generic()

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor

Chen Gang <gang.chen@asianux.com>
    powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries

Paul Mackerras <paulus@samba.org>
    powerpc: Fix emulation of illegal instructions on PowerNV platform

Kevin McKinney <klmckinney1@gmail.com>
    Staging: bcm: Add two products and remove an existing product.

Kevin McKinney <klmckinney1@gmail.com>
    Staging: bcm: Create and initialize new device id in InterfaceInit

Dan Carpenter <dan.carpenter@oracle.com>
    staging: wlags49_h2: buffer overflow setting station name

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: fix a race between do_cmd_ioctl() and read/write

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das08: Correct AI encoding for das08jr-16-ao

Alex Hung <alex.hung@canonical.com>
    ACPI video: ignore BIOS initial backlight value for HP 1000

Bastian Triller <bastian.triller@gmail.com>
    ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist

Corentin Chary <corentin.chary@gmail.com>
    acpi/video_detect: blacklist samsung x360

Mikulas Patocka <mpatocka@redhat.com>
    sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

NeilBrown <neilb@suse.de>
    md: flush writes before starting a recovery.

Michal Nazarewicz <mina86@mina86.com>
    tools: ffs-test: fix header values endianess

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix rare symlink decoding bug

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: preserve the high 32-bits of the PAT register

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Increase the number of fixed MTRR regs to 10

Steve French <smfrench@gmail.com>
    CIFS: fix mount failure with broken pathnames when smb3 mount with mapchars option

Rafał Miłecki <zajec5@gmail.com>
    b43: fix frequency reported on G-PHY with /new/ firmware

David R. Piegdon <lkml@p23q.org>
    ARM: OMAP2+: Fix parser-bug in platform muxing code

Arik Nemtsov <arik@wizery.com>
    mac80211: don't check netdev state for debugfs read/write

Syam Sidhardhan <s.syam@samsung.com>
    Bluetooth: Remove unused hci_le_ltk_reply()

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix SSP acceptor just-works confirmation without MITM

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix incorrect write to read-only register v2:

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: fix dithering on certain panels

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in radeon_connector_is_dp12_capable()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    mtd: pxa3xx_nand: make the driver work on big-endian systems

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: fix rfkill regression on rt2500pci

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: disable TKIP on USB

Michal Nazarewicz <mina86@mina86.com>
    usb: gadget: f_fs: fix NULL pointer dereference when there are no strings

Johan Hovold <johan@kernel.org>
    USB: ftdi_sio: fix null deref at port probe

Bjørn Mork <bjorn@mork.no>
    usb: option: add/modify Olivetti Olicard modems

Oliver Neukum <oneukum@suse.de>
    USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Bjørn Mork <bjorn@mork.no>
    USB: add USB_DEVICE_INTERFACE_CLASS macro

Wang, Yu <yu.y.wang@intel.com>
    xhci: Fix runtime suspended xhci from blocking system suspend.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Brian King <brking@linux.vnet.ibm.com>
    ibmvscsi: Abort init sequence during error recovery


-------------

Diffstat:

 Makefile                                   |  4 +--
 arch/arm/mach-omap2/mux.c                  |  6 ++--
 arch/powerpc/kernel/exceptions-64s.S       |  2 +-
 arch/powerpc/kernel/lparcfg.c              | 24 ++++++-------
 arch/powerpc/kernel/setup_64.c             |  2 +-
 arch/powerpc/kernel/sysfs.c                | 18 ++++++++--
 arch/powerpc/kernel/time.c                 |  4 +--
 arch/powerpc/kernel/traps.c                | 10 ++++++
 arch/powerpc/lib/checksum_64.S             | 54 ++++++++++++++++++++++--------
 arch/x86/include/asm/kvm_host.h            |  4 +--
 drivers/acpi/video.c                       | 16 +++++++++
 drivers/acpi/video_detect.c                | 45 +++++++++++++++++++++++++
 drivers/gpu/drm/radeon/atombios_crtc.c     | 48 ++++++++++++++------------
 drivers/gpu/drm/radeon/atombios_encoders.c |  5 ++-
 drivers/gpu/drm/radeon/radeon_connectors.c |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c         |  1 -
 drivers/md/md.c                            | 13 +++++++
 drivers/mtd/nand/pxa3xx_nand.c             |  4 +--
 drivers/net/wireless/b43/xmit.c            | 10 ++++--
 drivers/net/wireless/rt2x00/rt2500pci.c    |  7 +++-
 drivers/net/wireless/rt2x00/rt2x00.h       |  1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c    | 24 +++++++++++--
 drivers/net/wireless/rt2x00/rt2x00mac.c    |  2 ++
 drivers/scsi/ibmvscsi/ibmvscsi.c           |  3 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c        |  4 +++
 drivers/staging/bcm/InterfaceInit.c        |  4 ++-
 drivers/staging/bcm/InterfaceInit.h        |  5 +--
 drivers/staging/comedi/comedi_fops.c       | 25 ++++++++------
 drivers/staging/comedi/drivers/das08.c     |  2 +-
 drivers/staging/wlags49_h2/wl_priv.c       |  9 +++--
 drivers/usb/gadget/f_fs.c                  | 12 ++++---
 drivers/usb/host/xhci-ring.c               |  2 +-
 drivers/usb/host/xhci.c                    | 10 ++++--
 drivers/usb/serial/ftdi_sio.c              |  7 ++--
 drivers/usb/serial/option.c                | 26 ++++++++++----
 fs/cifs/cifs_unicode.c                     |  7 ++--
 fs/nfsd/nfs4proc.c                         |  9 -----
 fs/nfsd/nfs4xdr.c                          | 13 ++++++-
 include/linux/usb.h                        | 16 +++++++++
 include/net/bluetooth/hci_core.h           |  1 -
 net/bluetooth/hci_conn.c                   | 16 ---------
 net/bluetooth/hci_event.c                  |  7 ++--
 net/mac80211/debugfs_netdev.c              |  6 ++--
 tools/usb/ffs-test.c                       |  4 +--
 44 files changed, 347 insertions(+), 147 deletions(-)



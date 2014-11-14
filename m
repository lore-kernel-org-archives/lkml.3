Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaKNUOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:14:10 -0500
Received: from mail-bn1bon0136.outbound.protection.outlook.com ([157.56.111.136]:8382
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755079AbaKNUOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:14:08 -0500
X-WSS-ID: 0NF1OS3-07-H63-02
X-M-MSG: 
Date: Fri, 14 Nov 2014 21:57:34 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
To: <airlied@gmail.com>
CC: <oded.gabbay@amd.com>, <John.Bridgman@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <alexander.deucher@amd.com>, <j.glisse@gmail.com>
Subject: [PULL] amdkfd-v6
Message-ID: <20141114195734.GA21668@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377424004)(199003)(164054003)(189002)(288314003)(46102003)(92566001)(21056001)(99396003)(110136001)(102836001)(86362001)(575784001)(44976005)(84676001)(15202345003)(120916001)(97756001)(19580395003)(83506001)(15975445006)(101416001)(33656002)(92726001)(64706001)(46406003)(20776003)(47776003)(50466002)(2351001)(229853001)(105586002)(31966008)(107046002)(23726002)(4396001)(87936001)(106466001)(77096003)(77156002)(62966003)(54356999)(36756003)(97736003)(50986999)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0201MB1007;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1007;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1007;
X-Forefront-PRVS: 03950F25EC
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1007;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Here is the pull request of amdkfd for 3.19.

There are three very minor changes vs. the v5 patch-set I released a week ago:
- Fix to the MAINTAINERS file, according to Joe Perches comments
- Update module version number to 0.7.0
- Update amdkfd-thunk interface number to 1.0

Here is the link to the v5 cover letter:
http://lists.freedesktop.org/archives/dri-devel/2014-November/071582.html

Here is the link to the email about the HSA RT Open Source:
http://lists.freedesktop.org/archives/dri-devel/2014-November/071995.html

Here is a link to the libhsakmt (thunk layer):
http://cgit.freedesktop.org/~gabbayo/libhsakmt

Thanks,
	Oded
	
The following changes since commit a015c1e92639cd65ebb49350abdf5ad15bce4448:

  iommu/amd: fix accounting of device_state (2014-11-10 10:57:36 +0200)

are available in the git repository at:

  git://people.freedesktop.org/~gabbayo/linux amdkfd-v6

for you to fetch changes up to 6214ec0caab168c2615bd1ab72fbe5d0b673fe63:

  amdkfd: Implement the Get Version IOCTL (2014-11-02 12:18:29 +0200)

----------------------------------------------------------------
Alexey Skidanov (1):
      amdkfd: Implement the Get Process Aperture IOCTL

Andrew Lewycky (2):
      amdkfd: Add interrupt handling module
      amdkfd: Implement the Set Memory Policy IOCTL

Ben Goz (7):
      amdkfd: Add queue module
      amdkfd: Add mqd_manager module
      amdkfd: Add kernel queue module
      amdkfd: Add module parameter of scheduling policy
      amdkfd: Add packet manager module
      amdkfd: Add process queue manager module
      amdkfd: Add device queue manager module

Evgeny Pinchuk (2):
      amdkfd: Add topology module to amdkfd
      amdkfd: Implement the Get Clock Counters IOCTL

Oded Gabbay (12):
      drm/radeon: reduce number of free VMIDs and pipes in KV
      drm/radeon/cik: Don't touch int of pipes 1-7
      drm/radeon: Report doorbell configuration to amdkfd
      drm/radeon: adding synchronization for GRBM GFX
      drm/radeon: Add radeon <--> amdkfd interface
      Update MAINTAINERS and CREDITS files with amdkfd info
      amdkfd: Add IOCTL set definitions of amdkfd
      amdkfd: Add amdkfd skeleton driver
      amdkfd: Add basic modules to amdkfd
      amdkfd: Add binding/unbinding calls to amd_iommu driver
      amdkfd: Implement the create/destroy/update queue IOCTLs
      amdkfd: Implement the Get Version IOCTL

 CREDITS                                            |    7 +
 MAINTAINERS                                        |   10 +
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/amd/amdkfd/Kconfig                 |   10 +
 drivers/gpu/drm/amd/amdkfd/Makefile                |   14 +
 drivers/gpu/drm/amd/amdkfd/cik_regs.h              |  221 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  576 +++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h              |  294 +++++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  307 +++++
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 1059 +++++++++++++++++
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |  146 +++
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |  255 ++++
 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c       |  355 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c         |  176 +++
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c      |  347 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.h      |   69 ++
 drivers/gpu/drm/amd/amdkfd/kfd_module.c            |  159 +++
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |  346 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h       |   91 ++
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c    |  565 +++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c             |   97 ++
 drivers/gpu/drm/amd/amdkfd/kfd_pm4_headers.h       |  405 +++++++
 drivers/gpu/drm/amd/amdkfd/kfd_pm4_opcodes.h       |  107 ++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  598 ++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  415 +++++++
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  342 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   85 ++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          | 1235 ++++++++++++++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h          |  168 +++
 drivers/gpu/drm/amd/include/kgd_kfd_interface.h    |  185 +++
 drivers/gpu/drm/radeon/Makefile                    |    1 +
 drivers/gpu/drm/radeon/cik.c                       |  155 +--
 drivers/gpu/drm/radeon/cik_reg.h                   |  136 +++
 drivers/gpu/drm/radeon/cikd.h                      |   53 +-
 drivers/gpu/drm/radeon/radeon.h                    |   10 +
 drivers/gpu/drm/radeon/radeon_device.c             |   32 +
 drivers/gpu/drm/radeon/radeon_drv.c                |    5 +
 drivers/gpu/drm/radeon/radeon_kfd.c                |  563 +++++++++
 drivers/gpu/drm/radeon/radeon_kfd.h                |   47 +
 drivers/gpu/drm/radeon/radeon_kms.c                |    7 +
 include/uapi/linux/kfd_ioctl.h                     |  154 +++
 42 files changed, 9715 insertions(+), 95 deletions(-)
 create mode 100644 drivers/gpu/drm/amd/amdkfd/Kconfig
 create mode 100644 drivers/gpu/drm/amd/amdkfd/Makefile
 create mode 100644 drivers/gpu/drm/amd/amdkfd/cik_regs.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_crat.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_flat_memory.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_interrupt.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_kernel_queue.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_module.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pm4_headers.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_pm4_opcodes.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_priv.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_process.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_queue.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_topology.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/kfd_topology.h
 create mode 100644 drivers/gpu/drm/amd/include/kgd_kfd_interface.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
 create mode 100644 include/uapi/linux/kfd_ioctl.h

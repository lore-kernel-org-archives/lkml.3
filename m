Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaKRI67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:58:59 -0500
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:63010
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750912AbaKRI66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:58:58 -0500
X-WSS-ID: 0NF88Y0-08-PN1-02
X-M-MSG: 
Date: Tue, 18 Nov 2014 10:58:31 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>
CC: Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        John Bridgman <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Joerg Roedel <joro@8bytes.org>
Subject: [PULL resend] amdkfd-v6
Message-ID: <20141118085831.GA17806@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(189002)(377424004)(199003)(52084003)(164054003)(86362001)(83506001)(15975445006)(64706001)(92726001)(102836001)(97756001)(19580395003)(44976005)(23726002)(77156002)(92566001)(62966003)(68736004)(50466002)(84676001)(15202345003)(101416001)(20776003)(46406003)(46102003)(54356999)(47776003)(110136001)(99396003)(50986999)(33656002)(87936001)(107046002)(36756003)(229853001)(120916001)(4396001)(31966008)(95666004)(106466001)(105586002)(21056001)(77096003)(97736003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Forefront-PRVS: 039975700A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Resending the pull request of amdkfd for 3.19 per your request.

Change from original pull-request is removing the line "default m" from the
Kconfig file of amdkfd.

Here is the link to the previous pull request:
http://lists.freedesktop.org/archives/dri-devel/2014-November/072053.html

Thanks,
	Oded
	
The following changes since commit a015c1e92639cd65ebb49350abdf5ad15bce4448:

  iommu/amd: fix accounting of device_state (2014-11-10 10:57:36 +0200)

are available in the git repository at:

  git://people.freedesktop.org/~gabbayo/linux amdkfd-v6

for you to fetch changes up to ecd5c9821c39626fa7c03e9c397586b24cb11b79:

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
 drivers/gpu/drm/amd/amdkfd/Kconfig                 |    9 +
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
 42 files changed, 9714 insertions(+), 95 deletions(-)
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

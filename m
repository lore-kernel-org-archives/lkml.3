Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3CUTQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:16:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6974 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3CUTQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:16:50 -0400
X-IronPort-AV: E=Sophos;i="4.84,888,1355097600"; 
   d="scan'208";a="14091204"
Date: Thu, 21 Mar 2013 19:16:08 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: xen/arm: move to mach-virt and support SMP
Message-ID: <alpine.DEB.2.02.1303211848150.5135@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series, based on 3.9-rc3, moves xenvm to mach-virt and
implements SMP support in Xen on ARM.


Stefano Stabellini (4):
      xen/arm: implement HYPERVISOR_vcpu_op
      xen/arm: SMP support
      xen: move the xenvm machine to mach-virt
      xenvm: add a simple PSCI node and a second cpu

 arch/arm/boot/dts/xenvm-4.2.dts      |   12 +++++++++
 arch/arm/include/asm/xen/hypercall.h |    1 +
 arch/arm/mach-vexpress/v2m.c         |    1 -
 arch/arm/mach-virt/virt.c            |    1 +
 arch/arm/xen/enlighten.c             |   43 ++++++++++++++++++++++++++++++++-
 arch/arm/xen/hypercall.S             |    1 +
 6 files changed, 56 insertions(+), 3 deletions(-)

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.9-rc3-smp

Cheers,

Stefano

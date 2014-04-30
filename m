Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbaD3Ny1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:54:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40228 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaD3NyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:54:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, jbeulich@suse.com
Subject: [PATCH v1] Documentation and two bug-fixes for Xen pciback.
Date: Wed, 30 Apr 2014 09:54:05 -0400
Message-Id: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

This patchset is just a simple documentation and two bug-fixes
to the Xen pciback. I am still looking at implementing the proper
way of doing reset for the devices - based on David's feedback - but
that is going to take a big of time. In the meantime this patchset
is presented as today is the documentation day!


 drivers/xen/xen-pciback/pci_stub.c | 25 +++++++++++++++++++------
 drivers/xen/xen-pciback/xenbus.c   |  4 ++++
 2 files changed, 23 insertions(+), 6 deletions(-)

Konrad Rzeszutek Wilk (6):
      xen-pciback: Cleanup up pcistub_put_pci_dev
      xen-pciback: First reset, then free.
      xen-pciback: Document when we FLR an PCI device.
      xen/pciback: Document when the 'unbind' and 'bind' functions are called.
      xen/pciback: Document the entry points for 'pcistub_put_pci_dev'
      xen/pciback: Don't call xen_pcibk_config_init_dev when device de-assigned.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaG2EH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 00:07:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaG2EHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 00:07:24 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH 0/4 v3] Introduce device assignment flag operation helper function 
Date: Tue, 29 Jul 2014 12:06:27 +0800
Message-Id: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces three PCI device flag operation helper functions
when set pci device PF/VF to assigned or deassigned status also check it.
and patch 2,3,4 apply these helper functions to KVM,XEN and PCI.

v2: simplify unnecessory ternary operation in function pci_is_dev_assigned().
v3: amend helper function naming. 

Appreciate suggestion from
alex.williamson@redhat.com,
david.vrabel@citrix.com,
alexander.h.duyck@intel.com


BR,
Ethan



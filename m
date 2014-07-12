Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaGLVKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 17:10:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37370 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGLVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 17:10:39 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: [PATCH v2 0/2] xen: Silence compiler warnings
Date: Sat, 12 Jul 2014 23:09:46 +0200
Message-Id: <1405199388-5692-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two patches that follow earlier Xen dom0 EFI series and
fix some compiler warnings found during detailed build tests.

Both patches should be applied to:

git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next

v2 contains fix suggested by Konrad Rzeszutek Wilk.

Daniel

PS I will be on vacation from 14th Jul till 25th Jul.

 arch/x86/xen/Makefile    |    1 +
 arch/x86/xen/efi.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c |   15 +--------------
 arch/x86/xen/xen-ops.h   |    8 ++++++++
 include/xen/xen-ops.h    |    2 +-
 5 files changed, 54 insertions(+), 15 deletions(-)

Daniel Kiper (2):
      xen: Silence compiler warnings
      arch/x86/xen: Silence compiler warnings


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaGKTzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:55:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18089 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaGKTzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:55:04 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: [PATCH 0/2] xen: Silence compiler warnings
Date: Fri, 11 Jul 2014 21:54:19 +0200
Message-Id: <1405108461-3223-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are two patches that follow earlier Xen dom0 EFI series and
fix some compiler warnings found during detailed build tests.

Both patches should be applied to:

git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next

Daniel

PS I will be on vacation from 14th Jul till 25th Jul.

 arch/x86/xen/enlighten.c |   35 ++++++++++++++++++++++-------------
 include/xen/xen-ops.h    |    2 +-
 2 files changed, 23 insertions(+), 14 deletions(-)

Daniel Kiper (2):
      xen: Silence compiler warnings
      arch/x86/xen: Silence compiler warnings


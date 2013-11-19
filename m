Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3KSOyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:54:04 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41027 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3KSOyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:54:01 -0500
From: Dan Aloni <alonid@stratoscale.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        gleb@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: 
Date: Tue, 19 Nov 2013 16:53:28 +0200
Message-Id: <1384872810-29492-1-git-send-email-alonid@stratoscale.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following two patches address an integration issue between KVM and
KGDB. The issue described in the patches can be triggered with vanilla
kernels that enable KGDB and KVM together on x86 (more specifically,
we bump into this with Fedora's 3.11 kernel from FC19).

On a kernel enabled with KGDB, running with kvm-unit-tests should
reproduce the issue. On VM hosts servers where an admin accidently
left an active KGDB, and unprivilged guest might be able to bring
the host down.

Patches apply to linux-next and earlier kernels.


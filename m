Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3DLUPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:15:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37030 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab3DLUO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:14:28 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 0/6] kernel ASLR
Date: Fri, 12 Apr 2013 13:13:41 -0700
Message-Id: <1365797627-20874-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This splits up the relocs tool changes into the separate logical pieces,
which should be easier to review. I could use some suggestions on a
better way to build it in the 4th patch. What I have now seems ugly,
but Kbuild would not give me its secrets.

RO IDT was sent separately is is living in the tip/kaslr tree at the
moment. The main logic for KASLR remains split into two pieces: offset
selection and offset usage.

Thanks,

-Kees


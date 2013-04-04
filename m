Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429Ab3DDUIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:08:11 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43366 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764118Ab3DDUIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:08:09 -0400
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
Subject: [PATCH 0/3] kernel ASLR
Date: Thu,  4 Apr 2013 13:07:32 -0700
Message-Id: <1365106055-22939-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series implements per-boot kernel base offset ASLR. It is based
on work by Dan Rosenberg, Neill Clift, Michael Davidson, and myself. Since
Dan's original thread[1], this code has been improved to work on 64-bit,
among other things.

This is presently in use at Google, and is being ported to Chrome
OS. It has several limitations currently, but I wanted to get the ball
rolling again on upstreaming this. More details are in the individual
patches. They are split into three pieces: the offset selection logic,
the 64-bit relocation logic, and finally putting the offset to use at
boot time.

Thanks,

-Kees
 
[1] http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/index.html#00520


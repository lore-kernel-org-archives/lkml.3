Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaB0BC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:02:26 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53203 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaB0BCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:02:25 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] Improvements/fixes to 32-bit vdso timing
Date: Wed, 26 Feb 2014 17:02:12 -0800
Message-Id: <cover.1393462777.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa, please either nuke x86/vdso or apply these.  That branch is
certainly *not* ready for merging, but this gets it a little closer.

Andy Lutomirski (2):
  x86: Mark __vdso entries as asmlinkage
  x86: Inline the CLOCK_MONOTONIC vdso code

 arch/x86/vdso/vclock_gettime.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
1.8.5.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaE2V5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:57:24 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63970 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaE2V5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:57:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86,vdso: vdso build fixes and improvements
Date: Thu, 29 May 2014 14:57:16 -0700
Message-Id: <cover.1401400316.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 causes make;make to behave similarly to make if vdso2c fails.
Patch 2 hopefully fixes x86 crossbuilds on big-endian machines.  I don't
have a big-endian machine to test on, though.

Andy Lutomirski (2):
  x86,vdso: When vdso2c fails, unlink the output
  x86,vdso: Fix cross-compilation from big-endian architectures

 arch/x86/vdso/vdso2c.c | 35 ++++++++++++++++++-------
 arch/x86/vdso/vdso2c.h | 69 ++++++++++++++++++++++++++------------------------
 2 files changed, 62 insertions(+), 42 deletions(-)

-- 
1.9.3


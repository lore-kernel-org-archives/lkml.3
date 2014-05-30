Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbaE3PtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:49:23 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48782 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaE3Psy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:48:54 -0400
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
Subject: [PATCH v2 0/2] x86,vdso: vdso build fixes and improvements
Date: Fri, 30 May 2014 08:48:47 -0700
Message-Id: <cover.1401464755.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 causes make;make to behave similarly to make if vdso2c fails.
Patch 2 hopefully fixes x86 crossbuilds on big-endian machines.  I don't
have a big-endian machine to test on, though.

Changes from v1: Add two missing endian fixes

Andy Lutomirski (2):
  x86,vdso: When vdso2c fails, unlink the output
  x86,vdso: Fix cross-compilation from big-endian architectures

 arch/x86/vdso/vdso2c.c | 35 +++++++++++++++++-------
 arch/x86/vdso/vdso2c.h | 73 ++++++++++++++++++++++++++------------------------
 2 files changed, 64 insertions(+), 44 deletions(-)

-- 
1.9.3


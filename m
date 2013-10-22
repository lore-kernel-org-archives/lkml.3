Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JVQIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:08:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:3152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab3JVQIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422985815"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Various more LTO fixes for x86
Date: Tue, 22 Oct 2013 09:07:52 -0700
Message-Id: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Various asmlinkage fixes to mark all symbols used from
assembler visible.
- Some inline assembler fixes to avoid direct references
to non global symbols
- Move the global register variable for sp to inline
assembler. This fixes both LTO and apparently clang/LLVM too.

-Andi

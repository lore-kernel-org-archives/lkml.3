Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3KYChE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 21:37:04 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46598 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3KYCg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 21:36:59 -0500
Message-ID: <5292B845.3010404@gmail.com>
Date: Mon, 25 Nov 2013 10:39:01 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] arch: hexagon: include: asm: add prefix "vm_" for all
 enum members in "hexagon_vm.h"
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org>
In-Reply-To: <20131125011938.GB18921@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Append "vm_" to all enum members (which are too common to make conflict
with another sub-systems). The related error with allmodconfig:

    CC [M]  drivers/md/raid1.o
  drivers/md/raid1.c:1440:13: error: 'status' redeclared as different kind of symbol
  arch/hexagon/include/asm/hexagon_vm.h:76:2: note: previous definition of 'status' was here

Also fix a typo issue: use 'affinity' instead of 'locdis' for
__vmintop_affinity() in "hexagon_vm.h"


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/include/asm/hexagon_vm.h |   72 ++++++++++++++++----------------
 1 files changed, 36 insertions(+), 36 deletions(-)

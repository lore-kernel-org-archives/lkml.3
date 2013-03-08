Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab3CHCmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:42:31 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57123 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3CHCma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:42:30 -0500
From: Vinson Lee <vlee@twitter.com>
To: linux-kernel@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>
Subject: [PATCH v2] perf tools: Fix LIBNUMA build with glibc 2.12 and older.
Date: Thu,  7 Mar 2013 18:42:14 -0800
Message-Id: <1362710535-7219-1-git-send-email-vlee@twitter.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAKixpbiLtuYW4Tt770EEHxJK03Kq=LKtQzXULb2p5E_zh2Oc4w@mail.gmail.com>
References: <CAKixpbiLtuYW4Tt770EEHxJK03Kq=LKtQzXULb2p5E_zh2Oc4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This follow-up patch adds tokens MADV_HUGEPAGE and MADV_NOHUGEPAGE for 
Parisc, which has different values from other architectures.

Vinson Lee (1):
  perf tools: Fix LIBNUMA build with glibc 2.12 and older.

 tools/perf/bench/bench.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)


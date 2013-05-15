Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab3EOObg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:31:36 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46599 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3EOObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:31:34 -0400
Message-ID: <51939C3F.4060207@gmail.com>
Date: Wed, 15 May 2013 22:31:27 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] x86, cleanup: minor cleanups for reserve_crashkernel
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch 1 fixes an out-of-data comment.
patch 2 uses pr_info instead of printk.

Zhang Yanfei (2):
  x86, kexec: Correct comment in reserve_crashkernel
  x86, setup: Use pr_info instead of printk(KERN_INFO...)

 arch/x86/kernel/setup.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

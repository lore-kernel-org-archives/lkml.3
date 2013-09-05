Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab3IETP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:15:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab3IETPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:15:24 -0400
Date: Thu, 05 Sep 2013 15:15:22 -0400 (EDT)
Message-Id: <20130905.151522.845113235905620919.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sparc64: Export flush_ptrace_access() (needed by
 lustre)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378372653-5822-1-git-send-email-geert@linux-m68k.org>
References: <1378372653-5822-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 12:15:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu,  5 Sep 2013 11:17:33 +0200

> ERROR: "flush_ptrace_access" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
> undefined!
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> v2: Use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL

Applied, thank you.

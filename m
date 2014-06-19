Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaFSAFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 20:05:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36285 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaFSAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 20:05:23 -0400
Date: Wed, 18 Jun 2014 17:05:22 -0700 (PDT)
Message-Id: <20140618.170522.253556263376208566.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, ast@plumgrid.com, dborkman@redhat.com,
        edumazet@google.com, chema@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: filter: fix upper BPF instruction limit
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140618223457.GA31568@www.outflux.net>
References: <20140618223457.GA31568@www.outflux.net>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Jun 2014 17:05:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Jun 2014 15:34:57 -0700

> The original checks (via sk_chk_filter) for instruction count uses ">",
> not ">=", so changing this in sk_convert_filter has the potential to break
> existing seccomp filters that used exactly BPF_MAXINSNS many instructions.
> 
> Fixes: bd4cf0ed331a ("net: filter: rework/optimize internal BPF interpreter's instruction set")
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied, thanks.

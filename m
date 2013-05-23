Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949Ab3EWXau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 19:30:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63295 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783Ab3EWXat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 19:30:49 -0400
From: Stephen Mell <sub.atomic.fusion@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: move proc mount options out of pid_namespace
Date: Thu, 23 May 2013 23:32:30 +0000
Message-ID: <2515335.Kvy7Q1OKc4@pegasus>
User-Agent: KMail/4.9.5 (Linux/3.9.3; KDE/4.9.5; x86_64; ; )
In-Reply-To: <519DED89.9000409@cn.fujitsu.com>
References: <3342521.NtikuogILA@pegasus> <519DED89.9000409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 23, 2013 18:20:57 Gu Zheng wrote:

> Here it'll create a new proc sb instance which holds the same context as the old ones
> each time we mount proc though in the same PID namespace, won't it?
I believe so. But this is the point, right? They won't be identical if different mount options are used, I don't think.

> Here the pre-check seems needless.
Is that new with my patch, or has it always been needless?

Thanks,
Stephen

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaKPTXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:23:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37767 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaKPTXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:23:09 -0500
Date: Sun, 16 Nov 2014 14:23:02 -0500 (EST)
Message-Id: <20141116.142302.1012229415553740809.davem@davemloft.net>
To: drysdale@google.com
Cc: ebiederm@xmission.com, luto@amacapital.net, viro@zeniv.linux.org.uk,
        meredydd@senatehouse.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, oleg@redhat.com, mtk.manpages@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        keescook@chromium.org, arnd@arndb.de, dalias@aerifal.cx,
        hch@infradead.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCHv8 3/4] sparc: Hook up execveat system call.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415982183-20525-4-git-send-email-drysdale@google.com>
References: <1415982183-20525-1-git-send-email-drysdale@google.com>
	<1415982183-20525-4-git-send-email-drysdale@google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 11:23:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Drysdale <drysdale@google.com>
Date: Fri, 14 Nov 2014 16:23:02 +0000

> Signed-off-by: David Drysdale <drysdale@google.com>

Acked-by: David S. Miller <davem@davemloft.net>

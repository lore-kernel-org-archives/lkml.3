Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaKXSgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:36:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51145 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbaKXSgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:36:31 -0500
Date: Mon, 24 Nov 2014 13:36:26 -0500 (EST)
Message-Id: <20141124.133626.1699726793112808350.davem@davemloft.net>
To: drysdale@google.com
Cc: ebiederm@xmission.com, luto@amacapital.net, viro@zeniv.linux.org.uk,
        meredydd@senatehouse.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        oleg@redhat.com, mtk.manpages@gmail.com, mingo@redhat.com,
        hpa@zytor.com, keescook@chromium.org, arnd@arndb.de, dalias@aerifal.cx,
        hch@infradead.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCHv10 4/5] sparc: Hook up execveat system call.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416830039-21952-5-git-send-email-drysdale@google.com>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
	<1416830039-21952-5-git-send-email-drysdale@google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 10:36:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Drysdale <drysdale@google.com>
Date: Mon, 24 Nov 2014 11:53:58 +0000

> Signed-off-by: David Drysdale <drysdale@google.com>

Acked-by: David S. Miller <davem@davemloft.net>> 

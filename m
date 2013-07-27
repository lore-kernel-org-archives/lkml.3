Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3G0K0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 06:26:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37470 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3G0K0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 06:26:37 -0400
Date: Sat, 27 Jul 2013 12:26:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] relay: fix timer madness v3
Message-ID: <20130727102627.GB6923@pd.tnic>
References: <51F3710B.3040304@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51F3710B.3040304@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 03:04:43PM +0800, zhangwei(Jovi) wrote:
> Changed from v2:
> mod timer interval changed from HZ/10 to jiffies + HZ/10,
> as Dan Carpenter suggested.
> 
> This patch is based on -mm tree.

This is one of those guess-what-I'm-thinking commit messages. Can you
please write it this way:

The situation currently is A, the bug is B, I'm fixing it by doing C.

Don't be afraid to be more verbose.

An innocent bystander can only guess why the change was done and I'm
willing to bet good money that a couple of years from now, not even you
will know why you did it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

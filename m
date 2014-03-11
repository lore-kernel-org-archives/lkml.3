Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaCKGOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:14:25 -0400
Received: from ozlabs.org ([203.10.76.45]:59171 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaCKGOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:14:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: behanw@converseincode.com, khali@linux-fr.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH] module: LLVMLinux: Remove unused function warning from __param_check macro
In-Reply-To: <1394219327-5591-1-git-send-email-behanw@converseincode.com>
References: <1394219327-5591-1-git-send-email-behanw@converseincode.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 11 Mar 2014 16:41:35 +1030
Message-ID: <87y50hw9go.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

behanw@converseincode.com writes:
> From: Mark Charlebois <charlebm@gmail.com>
>
> This code makes a compile time type check that is optimized away. Clang
> complains that it generates an unused function.
>
> I believe GCC won't complain for a static inline fuction but would if it
> was just a static function.
>
> Adding the unused attribute to the function declaration removes the warning.
>
> This code works for both gcc and clang.
>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>

Please include the actual warning clang spits out.  That helps because
(1) I know what you're referring to, and
(2) it helps others if they are later googling for the error.

I don't have any huge objections to this patch (__always_unused) though.

Thanks,
Rusty.

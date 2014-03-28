Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaC1SyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:54:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:45937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaC1SyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:54:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,752,1389772800"; 
   d="scan'208";a="482304478"
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 16/28] ktap: add runtime/amalg.c
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396014469-5937-17-git-send-email-jovi.zhangwei@gmail.com>
Date: Fri, 28 Mar 2014 11:52:43 -0700
In-Reply-To: <1396014469-5937-17-git-send-email-jovi.zhangwei@gmail.com> (Jovi
	Zhangwei's message of "Fri, 28 Mar 2014 09:47:37 -0400")
Message-ID: <878urunojo.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jovi Zhangwei <jovi.zhangwei@gmail.com> writes:

> Use amalgamation build make ktapvm.ko much smaller.
>
> No amalgamation build in x86_64:
> ktapvm.ko: 2.4M
>
> amalgamation build in x86_64:
> ktapvm.ko: 1.1M
>
> User can set use amalgamation build or not in Makefile.

This seems dubious. Is that due to debug information?

[if yes new enough toolchain can fix that]

If it's due to code something is seriously wrong, 
perhaps in your inlines.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

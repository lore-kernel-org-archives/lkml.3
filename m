Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaHASff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:35:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51081 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbaHASfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:35:34 -0400
Message-ID: <53DBDDE1.5070805@zytor.com>
Date: Fri, 01 Aug 2014 11:35:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
CC: Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct
 pt_regs"
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com> <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1406904498-21647-4-git-send-email-dvlasenk@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 07:48 AM, Denys Vlasenko wrote:
> 
> Patch was run-tested: 64-bit executables, 32-bit executables,
> strace works.
> 

Could you please try to see if there is a measurable change in the
latency of a trivial syscall?

	-hpa



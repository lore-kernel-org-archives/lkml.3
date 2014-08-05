Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaHEUNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:13:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40470 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbaHEUNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:13:41 -0400
Message-ID: <53E13AD9.5080908@zytor.com>
Date: Tue, 05 Aug 2014 13:13:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 0/8] x86: entry_64.S: always allocate complete "struct
 pt_regs"
References: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 07:52 AM, Denys Vlasenko wrote:
> Version 3 of the patchset.
> 
> Please consider applying at least two first patches, they are definitely safe,
> and the second one fixes a latent bug.
> 

Please do provide latency measurements.  I highly suspect that they will
turn out that that this has no significant impact on latency, but we
need to know for sure.

This is too late for 3.17 anyway, so we have some time.

	-hpa



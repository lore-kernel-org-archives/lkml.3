Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaHIA11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:27:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54394 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaHIA10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:27:26 -0400
Message-ID: <53E56ADB.1020203@zytor.com>
Date: Fri, 08 Aug 2014 17:27:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 0/17] x86: entry.S optimizations
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 10:44 AM, Denys Vlasenko wrote:
> Version 4 of the patchset.
> 
> Please consider applying at least two first patches, they are definitely safe,
> and the second one fixes a latent bug.
> 

Please note that the 3.17 merge window is currently open.  This is not
3.17 material at this point, so I'm not going to apply anything until
after Kernel Summit.

In other words, a few weeks to work out the kinks.

	-hpa



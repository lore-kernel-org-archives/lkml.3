Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3HJU1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 16:27:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35121 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779Ab3HJU1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 16:27:12 -0400
Message-ID: <5206A1FD.4020603@zytor.com>
Date: Sat, 10 Aug 2013 13:26:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mike Galbraith <bitbucket@online.de>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org> <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net> <5206659F.9070705@zytor.com> <CA+55aFyB5E+Keupjz4trfMcNawUKVzQV8DF5aS_VsPiw3FaT_Q@mail.gmail.com> <520675D3.7030703@zytor.com> <CA+55aFzhv1v9KatxQ3GUGBZf+zTb_hdx2fJZKT+m5tEcAkWsSQ@mail.gmail.com>
In-Reply-To: <CA+55aFzhv1v9KatxQ3GUGBZf+zTb_hdx2fJZKT+m5tEcAkWsSQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 11:51 AM, Linus Torvalds wrote:
> That "kernel_stack" thing is actually getting the thread_info pointer,
> and it doesn't get cached because gcc thinks the preempt_count value
> might alias.

This is just plain braindamaged.  Somewhere on my list of things is to
merge thread_info and task_struct and have a pointer to the unified
structure.

	-hpa


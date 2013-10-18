Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3JRNDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:03:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56329 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751684Ab3JRNDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:03:54 -0400
Message-ID: <526131B8.5030207@free-electrons.com>
Date: Fri, 18 Oct 2013 15:03:52 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        janne.karhunen@gmail.com
Subject: Re: [PATCH v2] init: make init failures more explicit
References: <1382097633-10166-1-git-send-email-michael.opdenacker@free-electrons.com> <CAMuHMdXas3ALeMXkj1YuDARVAL4Ln19UjXm8oRiGoLyKBc_B7A@mail.gmail.com>
In-Reply-To: <CAMuHMdXas3ALeMXkj1YuDARVAL4Ln19UjXm8oRiGoLyKBc_B7A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 02:20 PM, Geert Uytterhoeven wrote:
> On Fri, Oct 18, 2013 at 2:00 PM, Michael Opdenacker
> <michael.opdenacker@free-electrons.com> wrote:
>> +               pr_err("Starting init: %s exists but couldn't execute it (error: %d - see errno-base.h and errno.h)\n",
> IMHO the "- see errno-base.h and errno.h" is a bit overkill.
Yes, I was wondering. Good to have your opinion on this!

I'll post an update with just the error number, also adding the error
code to the other two "Failed to execute" error messages.

Thanks!

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3JRJc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:32:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55349 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009Ab3JRJc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:32:28 -0400
Message-ID: <5261001D.3090909@free-electrons.com>
Date: Fri, 18 Oct 2013 11:32:13 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] init: make init failures more explicit
References: <1382086049-14386-1-git-send-email-michael.opdenacker@free-electrons.com> <CAMuHMdWXWfGqw041pkOYKzLjQ05GfCcz9jOFQaPa=d_RwhOUcg@mail.gmail.com>
In-Reply-To: <CAMuHMdWXWfGqw041pkOYKzLjQ05GfCcz9jOFQaPa=d_RwhOUcg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 10/18/2013 11:23 AM, Geert Uytterhoeven wrote:
> On Fri, Oct 18, 2013 at 10:47 AM, Michael Opdenacker
> <michael.opdenacker@free-electrons.com> wrote:
>> +       if (ret && ret != -ENOENT) {
>> +               pr_err("Starting init: %s exists but couldn't execute it\n",
> I think it makes sense to also print the value of ret here.
> Apart from your -ENOEXEC case, peeking a bit around, it can be also be
> -EINVAL, -ENOMEM (debug binary too big for small embedded system?),
> -EACCES, -E2BIG, ...
I agree. It would definitely make sense. I'll propose a new version.

Many thanks!

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098


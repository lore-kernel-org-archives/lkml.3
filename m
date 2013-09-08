Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab3IHDfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:35:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51030 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759497Ab3IHDfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:35:17 -0400
Message-ID: <522BF072.8080807@free-electrons.com>
Date: Sun, 08 Sep 2013 05:35:14 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>, ak@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300: remove deprecated IRQF_DISABLED
References: <1378545345-8113-1-git-send-email-michael.opdenacker@free-electrons.com> <CAFLxGvw-OfsVcvqeCms5=V=pBhYPyvqjOZv04ZidMNPyB=7jBw@mail.gmail.com>
In-Reply-To: <CAFLxGvw-OfsVcvqeCms5=V=pBhYPyvqjOZv04ZidMNPyB=7jBw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 09/07/2013 11:21 AM, richard -rw- weinberger wrote:
> On Sat, Sep 7, 2013 at 11:15 AM, Michael Opdenacker
> <michael.opdenacker@free-electrons.com> wrote:
>> This patch proposes to remove the IRQF_DISABLED flag from h8300 architecture
>> code. It's a NOOP since 2.6.35 and it will be removed one day.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
>>  arch/h8300/kernel/timer/itu.c     | 2 +-
>>  arch/h8300/kernel/timer/timer16.c | 2 +-
>>  arch/h8300/kernel/timer/timer8.c  | 2 +-
>>  arch/h8300/kernel/timer/tpu.c     | 2 +-
>>  4 files changed, 4 insertions(+), 4 deletions(-)
> FYI, h8300 is gone:
> https://lkml.org/lkml/2013/8/30/383
Good to know, thanks! Then this patch is much more exhaustive than mine ;)

Cheers,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098


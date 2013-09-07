Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab3IGJVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 05:21:21 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57827 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3IGJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 05:21:19 -0400
MIME-Version: 1.0
In-Reply-To: <1378545345-8113-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378545345-8113-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Sat, 7 Sep 2013 11:21:19 +0200
Message-ID: <CAFLxGvw-OfsVcvqeCms5=V=pBhYPyvqjOZv04ZidMNPyB=7jBw@mail.gmail.com>
Subject: Re: [PATCH] h8300: remove deprecated IRQF_DISABLED
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>, ak@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 11:15 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This patch proposes to remove the IRQF_DISABLED flag from h8300 architecture
> code. It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/h8300/kernel/timer/itu.c     | 2 +-
>  arch/h8300/kernel/timer/timer16.c | 2 +-
>  arch/h8300/kernel/timer/timer8.c  | 2 +-
>  arch/h8300/kernel/timer/tpu.c     | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

FYI, h8300 is gone:
https://lkml.org/lkml/2013/8/30/383

-- 
Thanks,
//richard

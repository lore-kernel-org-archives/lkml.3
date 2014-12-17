Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaLQEWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:22:17 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:57693 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLQEWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:22:16 -0500
Message-ID: <549104F5.30902@acm.org>
Date: Tue, 16 Dec 2014 22:22:13 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Corey Minyard <cminyard@mvista.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ipmi tree
References: <20141217140353.04eebe5d@canb.auug.org.au>
In-Reply-To: <20141217140353.04eebe5d@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 09:03 PM, Stephen Rothwell wrote:
> Hi Corey,
>
> After merging the ipmi tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/char/ipmi/ipmi_ssif.c:55:26: fatal error: linux/ctypes.h: No such file or directory
>  #include <linux/ctypes.h>
>                           ^
>
> Caused by commit 707096b4dd41 ("ipmi: Fix compile issue with isspace()").
>
> I have used the ipmi tree from next-20141216 for today.
>
> Also, you seem to have rebased your tree and thus duplicated a whole
> series of commits that are now in Linus' tree :-(

These should be fixed now.  I'm still learning the finer points of git for
this type of work.

Thanks,

-corey

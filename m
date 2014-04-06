Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaDFPaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 11:30:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43835 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaDFP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 11:29:33 -0400
Date: Sun, 06 Apr 2014 11:31:06 -0400 (EDT)
Message-Id: <20140406.113106.564835222660199498.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: rdunlap@infradead.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 1 (netfilter)
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdXaoUvUButpaDYQh6aj=Zm9GCS7MKFA_-h8GOo1RkOObw@mail.gmail.com>
References: <533B06A7.5010900@infradead.org>
	<20140401.152203.847120817141929645.davem@davemloft.net>
	<CAMuHMdXaoUvUButpaDYQh6aj=Zm9GCS7MKFA_-h8GOo1RkOObw@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 06 Apr 2014 08:29:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 6 Apr 2014 15:50:04 +0200

> On Tue, Apr 1, 2014 at 9:22 PM, David Miller <davem@davemloft.net> wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>> Date: Tue, 01 Apr 2014 11:34:15 -0700
>>
>>> on x86_64:
>>>
>>> net/netfilter/xt_connlimit.c: In function 'connlimit_mt_check':
>>> net/netfilter/xt_connlimit.c:380:18: warning: division by zero [-Wdiv-by-zero]
>>>
>>> Maybe just use CONNLIMIT_LOCK_SLOTS instead of ARRAY_SIZE(...).
>>
>> I'd rather see that ARRAY_SIZE() be adjusted to work cleanly for zero
>> sized array elements.
> 
> Anyone with a suggestion?
> 
> Please note this is now in Linus' tree, possibly crashing people's boxes...

I took in the version of the fix I didn't like via Pablo for
now.

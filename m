Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575Ab3LINeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:34:31 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33255 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3LINe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:34:29 -0500
Message-ID: <52A5C6E1.8020406@gmail.com>
Date: Mon, 09 Dec 2013 21:34:25 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/zswap.c: add BUG() for default case in zswap_writeback_entry()
References: <52A53024.9090701@gmail.com> <52A5935A.4040709@imgtec.com> <52A5973A.7020509@gmail.com> <52A5990E.2080808@imgtec.com> <52A5A7B5.2040904@gmail.com> <52A5AC11.8050802@imgtec.com>
In-Reply-To: <52A5AC11.8050802@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 07:40 PM, James Hogan wrote:
> On 09/12/13 11:21, Chen Gang wrote:
>> Oh, I tried gcc 4.6.3-2 rhel version, get the same result as yours (do
>> not report warning), but for me, it is still a compiler's bug, it
>> *should* report a warning for it, we can try below:
> 
> Not necessarily. You can't expect the compiler to detect and warn about
> more complex bugs the programmer writes, so you have to draw the line
> somewhere.
> 

Yeah, we can not only depend on compiler to help us finding bugs.


> IMO missing some potential bugs is better than warning about code that
> isn't buggy since that just makes people ignore the warnings or
> carelessly try to silence them.
> 

I can understand, every members have their own taste, so this patch is
depended on related maintainers' taste (so kernel provided
"EXTRA_CFLAGS=-W" to satisfy some of guys taste -- e.g. me).  ;-)


Thanks
-- 
Chen Gang

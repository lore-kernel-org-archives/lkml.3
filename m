Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3DKE1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:27:54 -0400
Received: from intranet.asianux.com ([58.214.24.6]:64720 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3DKE1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:27:53 -0400
X-Spam-Score: -100.8
Message-ID: <51663BA6.1020500@asianux.com>
Date: Thu, 11 Apr 2013 12:27:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: kallsyms: parameters checking, for EXPORT_SYMBOL_GPL
 functions
References: <5163AE9A.8060505@asianux.com> <871uai7tzu.fsf@rustcorp.com.au> <51654557.3000308@asianux.com> <87ppy14w3u.fsf@rustcorp.com.au>
In-Reply-To: <87ppy14w3u.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 10:52, Rusty Russell wrote:
>>> >> Or is someone already doing this?
>>> >> 
>> >
>> >   really has:
>> >
>> >     kernel: __wake_up_sync_key in kernel/sched/core.c.
>> >     lib: *printf.
>> >     mm:  kfree.
> No, I mean "is someone calling these functions with NULL".
> 
> Cheers,
> Rusty.
> 
> 

  often "kfree(NULL)", that is ok. it will let caller easier using it.
  also often give 0 size to snprintf, it still let caller easy using.

  if we treat EXPORT functions of kallsyms as commonly used (or we want to)
    I suggest to give parameter check for them.


  thanks.

  :-)

-- 
Chen Gang

Asianux Corporation

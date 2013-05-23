Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab3EWFOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 01:14:15 -0400
Received: from intranet.asianux.com ([58.214.24.6]:64403 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3EWFOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 01:14:14 -0400
X-Spam-Score: -100.8
Message-ID: <519DA573.4010700@asianux.com>
Date: Thu, 23 May 2013 13:13:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] kernel/module.c: need return the first error code
 to upper caller when error occurs
References: <51889EE4.4070504@asianux.com> <87ip2unwkt.fsf@rustcorp.com.au> <5189C1D6.1040209@asianux.com> <87li7j3cgw.fsf@rustcorp.com.au> <51905EEF.2050901@asianux.com> <5190DB74.6050100@asianux.com> <51919E64.8020409@asianux.com> <5195B317.9030905@asianux.com> <519CAB4F.1000501@asianux.com> <87fvxes65b.fsf@rustcorp.com.au>
In-Reply-To: <87fvxes65b.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 11:54 AM, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
>> > Hello Maintainers:
>> >
>> > Please help check the patch whether OK or not, when you have time.
> Hi Chen,
> 
>         There's nothing *wrong* with the patch, but I don't think it's
> worthwhile.  If this were your very first kernel patch, I'd probably
> apply it just to encourage you, but you're not a newbie any more!

OK, I can understand.


Thanks.
-- 
Chen Gang

Asianux Corporation

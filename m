Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3CTOBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:01:52 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55613 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3CTOBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130318195136.GG3042@htj.dyndns.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
	<20130318195136.GG3042@htj.dyndns.org>
Date: Wed, 20 Mar 2013 23:01:50 +0900
Message-ID: <CAAmzW4N=t=aB194E-B185x1gqTJqNK4XO_diiaJrhjx+CN-_VA@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-3.10] workqueue: break up workqueue_lock into
 multiple locks
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/19 Tejun Heo <tj@kernel.org>:
> On Wed, Mar 13, 2013 at 07:57:18PM -0700, Tejun Heo wrote:
>> and available in the following git branch.
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-finer-locking
>
> Applied to wq/for-3.10.

Hello, Tejun.

I know I am late, but, please give me a change to ask a question.

Finer locking for workqueue code is really needed?
Is there a performance issue?
I think that there is too many locks and locking rules,
although the description about these are very nice.

Thanks.

> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

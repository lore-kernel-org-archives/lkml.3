Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaEIOJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:09:37 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:42659 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaEIOJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:09:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140509105149.GH4963@mwanda>
References: <20140509100606.GA6479@devel.8.8.4.4>
	<20140509105149.GH4963@mwanda>
Date: Fri, 9 May 2014 23:09:35 +0900
Message-ID: <CAHb8M2AopFJGhgZOu_hbn2YWvMgeuFz2zK2uYo4Fnt6kACKSOg@mail.gmail.com>
Subject: Re: [PATCH 2/5] staging: cxt1e1: remove dead code in musycc.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-09 19:51 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, May 09, 2014 at 07:06:06PM +0900, Daeseok Youn wrote:
>> Removes "#if 0" blocks.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> Dan,
>>  I decided to leave musycc_dump_rxbuffer_ring(ch, 0) which is commented
>>  out and make a block as "RLD_DEBUG". Because i think this block need to
>> debug
>>  with define "RLD_DEBUG". If I am wrong, let me know.
>>
>
> This change should maybe have been in a separate patch.  It's a border
> line thing.  But definitely, it should have been mentioned in the
> changelog.
>
> Btw, you can use `git citool` to add or remove lines from a
> commit.  Highlight and right click on the lines you want to add or
> remove.
Thanks for the tip. I used "git add -p" after "git rebase" and "git
reset HEAD" for
spliting a patch.
But I have a question, Do I have to resend rest of patches after
spliting this patch?
In this case, 2/5 is splited to two, it doesn't need to rebase but
numbering of patches are changed.

>
> I don't really care either way if you keep it or delete it.
Ok. I will leave this.

Thanks for review.

Regards,
Daeseok Youn

>
> regards,
> dan carpenter
>
>

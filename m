Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbaEIIWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:22:23 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:56647 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaEIIWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:22:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140509075904.GJ26890@mwanda>
References: <20140509013843.GA30927@devel.8.8.4.4>
	<20140509075904.GJ26890@mwanda>
Date: Fri, 9 May 2014 17:22:18 +0900
Message-ID: <CAHb8M2AOxLS_nA4BFy2q7+TyyLYxUTmzVULn8dvuR-X2fsET=w@mail.gmail.com>
Subject: Re: [PATCH 1/3] staging: cxt1e1: Fix no spaces at the start of a line
 in musycc.c
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        nandini h <nandu.hgowda@gmail.com>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        peter.p.waskiewicz.jr@intel.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Chekameh Cobbler <fempsci@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-09 16:59 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, May 09, 2014 at 10:38:43AM +0900, Daeseok Youn wrote:
>> clean up checkpatch.pl warning:
>>  WARNING: please no spaces at the start of a line in
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> This patch includes cleanup for fixing line length.
>>
>
> This patch is super hard to review.  Your "line length" fixes include
> moving variable declarations around, deleting comments, getting rid of
> nonsense curly braces.  Those are all great but the patch is over a
> thousand lines long and it's difficult to review.
Yes.. I knew that. And sorry about that. but I was really hard to
separate this patch for
fixing coding style. :-(
When I replaced spaces with tabs, it has too many tabs so I cannot leave
 that lines on this patch.(and removed curly braces can solve my concern..)
But I should do as your comment.

>
> If you just change spaces to tabs, that takes me 5 seconds to review
> because I have scripts and email macros to do that.
>
> If you just delete the #if 0 blocks that also is easy to review in a
> single patch.
OK. I will make a patch for that.
>
> Just delete all the code that depends on #ifdef RLD_DUMP_BUFDATA because
> that stuff is never set.
I think developer can be set with "#define RLD_DUMP_BUFDATA" for
debugging before
building this module. OK. I will remove that.
>
> Please break this up into smaller patches and also write a better
> changelog.
OK. sorry I will try breaking this up into smaller patches.
It need to take some time for this. :-)

Thanks for review.

Regards,
Daeseok Youn.
>
> regards,
> dan carpenter
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaEaRZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 13:25:13 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:48935 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaEaRZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 13:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140531065120.GK15585@mwanda>
References: <1401510680-13991-1-git-send-email-danieru.dressler@gmail.com>
	<20140531065120.GK15585@mwanda>
Date: Sat, 31 May 2014 11:25:10 -0600
Message-ID: <CAGC3nLAKKGGwN8fTyoragp4YyqiHD16kocuWq-FDa3ENDNb5Fg@mail.gmail.com>
Subject: Re: [PATCH] Staging: android: binder: Fix over-80-char lines
From: Daniel Dressler <danieru.dressler@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        serban.constantinescu@arm.com, linux-kernel@vger.kernel.org,
        arve@android.com, John Stultz <john.stultz@linaro.org>,
        prtvar.b@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Neil

I was not sure if space-based alignment was allowed so thank you for
demonstrating the change. It does make the code much easier to read.

Similar thank you for how to indent over-long function calls. I had
mis-understood the coding standard to mean overflow needed to be on
the far right margin. A single indent before the first argument looks
much nicer and consistent.

Thank you Dan

You are right! It does break the code. Thank you for finding that and
the name issue. I'll rewrite the patch on top of linux-next this time
with the proper style as Neil suggested. I think git send-email added
the danieru. I had tried fixing the name my git config and then git
amending but send-email continued adding the danieru address so I
assumed that it always took the current user's username. Now it sounds
like that was some metadata git did not redo upon amend.

Daniel

2014-05-31 0:51 GMT-06:00 Dan Carpenter <dan.carpenter@oracle.com>:
> What Neil said.
>
> On Fri, May 30, 2014 at 10:31:20PM -0600, Daniel Dressler wrote:
>> From: danieru <danieru.dressler@gmail.com>
>
> This is wrong and we also get your name and email address from the
> email headers so leave this line out.
>
>>
>> Following Greg Kroah-Hartman's newbie guide to hacking
>> the linux kernel this patch addresses only coding style
>> issues.
>>
>> Binder still has many too-long lines but I'm worried
>> doing too much work in a single patch is unfair to the
>> reviewers. So this patch address 20% of the file's
>> issues.
>>
>> There is one change to take notice of: it merges two if
>> statement's conditionals together. Then it removes a
>> redundant else clause.
>
> Thanks for pointing this out, but the else statement wasn't redundant.
> Your change introduces a bug.
>
> Your patch doesn't apply.  You need to work against linux-next.
>
> regards,
> dan carpenter
>

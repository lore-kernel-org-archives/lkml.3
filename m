Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaJ2Xjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:39:44 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:46555 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbaJ2Xjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <20141029092208.GA28631@kroah.com>
References: <20141026020853.GA28838@devel>
	<20141029092208.GA28631@kroah.com>
Date: Thu, 30 Oct 2014 08:39:42 +0900
Message-ID: <CAHb8M2AZ-cUe3st8YB2CtfKH6HG-7X0F1Zp_BjvmcSde4uzDog@mail.gmail.com>
Subject: Re: [PATCH RESEND] staging: dgap: re-arrange functions for removing
 forward declarations
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



2014-10-29 18:22 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Sun, Oct 26, 2014 at 11:08:54AM +0900, Daeseok Youn wrote:
>> Re-arrange the functions for removing forward declarations.
>>
>> Tested-by: Mark Hounschell <markh@compro.net>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> RESEND: This patch is tested all by Mark.
>> It is good to merge. Greg, check please.
>
> It doesn't apply to my tree :(
Yes, it need to rebase as Mark's comment.

I will send this again after rebase.

Thanks.
Daeseok Youn.

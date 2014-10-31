Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161603AbaJaBKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:10:41 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:62348 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161410AbaJaBKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:10:40 -0400
MIME-Version: 1.0
In-Reply-To: <20141030203317.GA8137@kroah.com>
References: <20141030031400.GA3312@devel>
	<20141030203317.GA8137@kroah.com>
Date: Fri, 31 Oct 2014 10:10:39 +0900
Message-ID: <CAHb8M2CiK0uLDn2BiWCg44z0=R-KwDFRKZNaUSc0Gxo_qNJnEw@mail.gmail.com>
Subject: Re: [PATCH V2] staging: dgap: re-arrange functions for removing
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

2014-10-31 5:33 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Thu, Oct 30, 2014 at 12:14:00PM +0900, Daeseok Youn wrote:
>> Re-arrange the functions for removing forward declarations.
>>
>> Tested-by: Mark Hounschell <markh@compro.net>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> Tested-by: Mark Hounschell <markh@compro.net>
>> ---
>> V2: this patch is rebased on staging-next branch.
>
> Still doesn't apply :(

You maybe merge this patch to staging-testing branch, right?
I tried to rebase this patch on staging-next but staging-testing had
two patches more from Tapasweni.

I will rebase on staging-testing and send this again.

Thanks.

regards,
Daeseok Youn.

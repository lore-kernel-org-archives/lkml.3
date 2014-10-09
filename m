Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaJIK3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:29:00 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:56578 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaJIK2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <20141009102341.GU23154@mwanda>
References: <20141009044011.GA999@devel>
	<20141009094902.GA4333@sudip-PC>
	<20141009102341.GU23154@mwanda>
Date: Thu, 9 Oct 2014 19:28:53 +0900
Message-ID: <CAHb8M2DG77BD7=8CuK2AcRPMW5cBbZfBwPqO+ofN3=fONFM_Hg@mail.gmail.com>
Subject: Re: [PATCH V2] staging: dgap: introduce dgap_stop()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-10-09 19:23 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Thu, Oct 09, 2014 at 03:19:03PM +0530, Sudip Mukherjee wrote:
>> On Thu, Oct 09, 2014 at 01:40:11PM +0900, Daeseok Youn wrote:
>> > The dgap_init_module() need to unwind for cleanup variables properly.
>> > Because dgap_init_module() calls dgap_cleanup_module() for freeing
>> > variables but this function is possible to free variables
>> > which are not allocated.
>> >
>> > Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> > ---
>> > V2: change ulong which is non-standard to "unsigned long".
>> I think , Dan, in his review of your v1 , asked you to rearrange the functions and get rid of the forward declarations.
>>
>
> I was fine with v1 actually...  It's a bug fix, and this is staging and
> there are tons of forward declarations already.  Eventually we need to
> get rid of them but it can be done later.
Yes, I will cleanup as your review.

thanks.

regards,
Daeseok Youn.

>
> regards,
> dan carpenter
>

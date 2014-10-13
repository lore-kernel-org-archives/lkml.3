Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaJMXoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 19:44:08 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:54146 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaJMXoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 19:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <1413212198.1287.9.camel@joe-AO725>
References: <20141013023425.GA15452@devel>
	<20141013032544.GA26646@kroah.com>
	<CAHb8M2A5e2akETQoWS6WfNJjUqhyu4ptfTMs9HLYgbw8XRR-Ww@mail.gmail.com>
	<1413212198.1287.9.camel@joe-AO725>
Date: Tue, 14 Oct 2014 08:44:05 +0900
Message-ID: <CAHb8M2DZOrwHTUvbgAa8Ld2P=Dw9LpnZcsusvbgwjabUeqg2Sg@mail.gmail.com>
Subject: Re: [PATCH] staging: dgap: re-arrange functions for removing forward declarations.
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>, devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-10-13 23:56 GMT+09:00 Joe Perches <joe@perches.com>:
> On Mon, 2014-10-13 at 17:01 +0900, DaeSeok Youn wrote:
>> Hi,
>>
>> 2014-10-13 12:25 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>> > On Mon, Oct 13, 2014 at 11:34:25AM +0900, Daeseok Youn wrote:
>> >> Re-arrange the functions for removing forward declarations.
>> >>
>> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> >> ---
>> >> This patch has too many changes for re-arranging the functions.
>> >> So I wonder that I should break this up into smaller patches.
>> >
>> > Are the .o files identical before and after this patch?  If so, it's
>> > fine.
>> Ok. I will check for that.
>
> The .o files shouldn't be identical after function reordering.
>
Is it possible to sort "objdump -d" output by function name?
I'm not sure but it can be checked after sorting.

I think greg want to know missing functions in this patch because this
has many changes.

thanks.

regards,
Daeseok Youn.

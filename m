Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaGIXZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:25:49 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38589 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaGIXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140709190200.GA8113@kroah.com>
References: <20140707012754.GA26042@devel.8.8.4.4>
	<20140709190200.GA8113@kroah.com>
Date: Thu, 10 Jul 2014 08:25:47 +0900
Message-ID: <CAHb8M2BHq6N-YSP9GvZiJ7c6wZwPv-S8c416foj3D0Rom3Z4hA@mail.gmail.com>
Subject: Re: [PATCH] staging: dgap: removes redundant null check and change
 paramter for dgap_maxcps_room()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-07-10 4:02 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Mon, Jul 07, 2014 at 10:27:54AM +0900, Daeseok Youn wrote:
>> Null checks for tty, un and ch are already done by caller,
>> so replace parameter "tty" with "ch" and "un".
>>
>> And also use a pointer for returning new bytes_available instead of
>> return variable.
>
> Why make that change?  It's nicer to return a real value where ever
> possible.  That's more like other "room" functions in the tty layer.
I was looking at use cases of dgap_maxcps_room() in dgap.c,
 byte_available variable in caller is reused for that. So I tried to
change like this patch.
>
> Care to fix this up to just do the first change you made to the function
> instead?
OK, I will just change parameters for dgap_maxcps_room() and send again.
thanks.

regards,
Daeseok Youn.
>
> thanks,
>
> greg k-h

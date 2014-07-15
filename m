Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaGOHZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:25:23 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33256 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaGOHZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:25:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140715064716.GR25880@mwanda>
References: <20140715030223.GA14406@devel.8.8.4.4>
	<20140715064716.GR25880@mwanda>
Date: Tue, 15 Jul 2014 16:25:19 +0900
Message-ID: <CAHb8M2BbTY8_napPcjmq+P+6qu=dGvSE4K=JN4O2P9bZDg5tVg@mail.gmail.com>
Subject: Re: [PATCH 6/8] staging: dgap: remove unneeded dgap_err()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <markh@compro.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan.

2014-07-15 15:47 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, Jul 15, 2014 at 12:02:23PM +0900, Daeseok Youn wrote:
>> The dgap_err() is printing a message with pr_err(),
>> so all those are replaced.
>>
>
> Take a look at how pr_fmt works.
>
> #define pr_fmt(fmt) "dgap: " fmt
>
> Then you can remove the "dgap: " from the beginning of each line.
OK. I will define pr_fmt and remove "dgap:" string in pr_xxx()

>
> Also all the "out of memory" messages can be removed because the kernel
> prints its own message for that.
OK. I will.

Thanks.

regards,
Daeseok Youn.
>
> regards,
> dan carpenter
>

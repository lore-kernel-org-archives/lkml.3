Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbaFCHzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:55:15 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33199 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbaFCHzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140603072203.GE15585@mwanda>
References: <20140603062728.GA7161@devel.8.8.4.4>
	<20140603072203.GE15585@mwanda>
Date: Tue, 3 Jun 2014 16:55:12 +0900
Message-ID: <CAHb8M2CzKN9ksfy7Jd_R7+XcuLT48YweYhEoBRATVaBOiXcauw@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: dgap: pass "brd" as a paramter to dgap_after_config_loaded()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-03 16:22 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, Jun 03, 2014 at 03:27:28PM +0900, Daeseok Youn wrote:
>> -static int dgap_after_config_loaded(int board)
>> +static int dgap_after_config_loaded(struct board_t *brd)
>>  {
>> +     int board = brd->boardnum;
>> +
>
> We don't need to use "board" in this function.  We can replaced
> "dgap_board[board]->" with "brd->"
OK. I will fix as your comment and resend.
Thanks

regards,
Daeseok Youn.
>
>>       /*
>>        * Initialize KME waitqueues...
>>        */
>
> regards,
> dan carpenter
>

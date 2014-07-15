Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaGOHc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:32:29 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:38460 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaGOHc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140715064125.GQ25880@mwanda>
References: <20140715030402.GA14411@devel.8.8.4.4>
	<20140715064125.GQ25880@mwanda>
Date: Tue, 15 Jul 2014 16:32:27 +0900
Message-ID: <CAHb8M2CoFhQAwRc5cKqkK4zq77yM6n_8r_jvU+MwHYLWyHosxw@mail.gmail.com>
Subject: Re: [PATCH 7/8] staging: dgap: introduce dgap_cleanup_nodes()
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

2014-07-15 15:41 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, Jul 15, 2014 at 12:04:02PM +0900, Daeseok Youn wrote:
>> When a configration file is parsed with dgap_parsefile(),
>> makes nodes for saving configrations for board.
>>
>> Making a node will allocate node memory and strings for saving
>> configrations with kstrdup().
>>
>> So these are freed when dgap is unloaded or failed to initialize.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> It MUST be needed to prevent memory leaks but
>> I'm not sure that I fix properly.
>>
>> Please review.
>
> This thread doesn't have Mark on the CC list and he's the only person
> who can actually test it properly.  Resend it and CC Mark
> Hounschell <markh@compro.net>.

Really? I'd added Mark to CC list.
hmm.. In your reply doesn't have Mark. I was checking sent-box, he is
in the CC list.

OK. I will try to send this again after fixing 6/7 and 8/8.
Thanks.

regards,
Daeseok Youn
>
> regards,
> dan carpenter
>

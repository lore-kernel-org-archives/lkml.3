Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaFBJjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:39:07 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:42729 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaFBJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140602080022.GT17724@mwanda>
References: <20140602051447.GA30379@devel.8.8.4.4>
	<20140602080022.GT17724@mwanda>
Date: Mon, 2 Jun 2014 18:39:04 +0900
Message-ID: <CAHb8M2BhK3hCXRvpEaW1R3-BRhnK6weXwGJpgaNsCe+gGD7=cg@mail.gmail.com>
Subject: Re: [PATCH 2/6 RESEND V2] staging: dgap: unwind on error in dgap_found_board()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mark Hounschell <markh@compro.net>,
        driverdev-devel@linuxdriverproject.org,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-02 17:00 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Mon, Jun 02, 2014 at 02:14:47PM +0900, Daeseok Youn wrote:
>> Adds a label for "kfree(brd)". And also remove
>> a state value as BOARD_FAILED in brd when dgap_do_remap() is failed.
>> Because "brd" will free after failure.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>> RESEND: this patch is included into newly series of patches.
>> V2: add "Reviewed-by" line in change log.
>
> Don't worry about this stuff, Greg's scripts pick it up, or if they
> don't, I don't care.
OK. I got that.

Thanks.
Daeseok Youn.
>
> regards,
> dan carpenter
>

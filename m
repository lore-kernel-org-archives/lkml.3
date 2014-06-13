Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaFMIQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:16:30 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:42701 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaFMIQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:16:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140613080017.GC5015@mwanda>
References: <20140613074147.GA31615@devel.8.8.4.4>
	<20140613080017.GC5015@mwanda>
Date: Fri, 13 Jun 2014 17:16:27 +0900
Message-ID: <CAHb8M2D=QCm0Aeci2NsEs71K5Ev-oKGOm7XqTU0=e6qm3Fcf7A@mail.gmail.com>
Subject: Re: [PATCH 5/9] staging: dgap: introduce dgap_tty_unregister()
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

Hi, Dan



2014-06-13 17:00 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, Jun 13, 2014 at 04:41:47PM +0900, Daeseok Youn wrote:
>> dgap_tty_unregister() will unregister serial_driver
>> and print_driver, and also free related variables.
>>
>
> Introducing a static function without a caller will cause a GCC warning
> about unused functions.
>
> Fold 5,7 and 8 together into one patch.  This is still "one thing per
> patch" because they can't be done separately.
OK. I will do. And then this series of patches will resend, right?

Thanks.

regards,
Daeseok Youn
>
> regards,
> dan carpenter
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaGKPXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:23:19 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61635 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaGKPXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:23:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140711132020.GZ25880@mwanda>
References: <20140711102434.GA22355@devel.8.8.4.4>
	<20140711132020.GZ25880@mwanda>
Date: Sat, 12 Jul 2014 00:23:16 +0900
Message-ID: <CAHb8M2CKbbhZ51_iorB7TLxb9JgEmVze1PQ_-WzpU4_uT2EsiQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] staging: dgap: removes redundant null check and
 change paramter for dgap_tty_digisetcustombaud()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Mark Hounschell <markh@compro.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan

2014-07-11 22:20 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> Looks good to me.  You should be CC'ing Mark as well.  He's in
> MAINTAINERS now.
I'd added Mark to cc list. All of maintainers including open mailing
lists from get_maintainer.pl were added in my patches. :-)

>
> I wish the two of you would CC each other and review each other's work.
I would like to review dgap patches.
>
> Daeseok, add yourself to the MAINTAINERS file for this driver as well so
> everyone CC's you on their dgap patches.  You're doing good work.
Really? :o
Can I modify the MAINTAINERS file for adding myself?

Thank you very much!!

Regards,
Daeseok Youn.

> regards,
> dan carpenter
>
>

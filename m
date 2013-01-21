Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3AUMLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:11:45 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:39114 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3AUMES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130121112424.GV16282@mwanda>
References: <20130120150258.GB32551@elgon.mountain>
	<20130121083245.GA11592@core.coreip.homeip.net>
	<1358760001.8234.150.camel@kjgkr>
	<CAKYAXd-H0KHMavYRk3PEshXNtN_ke5rH_qa-8XTT6RWZXYmFcw@mail.gmail.com>
	<20130121112424.GV16282@mwanda>
Date: Mon, 21 Jan 2013 21:04:15 +0900
Message-ID: <CAKYAXd9MONk+mwHSXnoUTVVHqFytFPpfth1uvpcKx9q=g2yPWw@mail.gmail.com>
Subject: Re: [patch] f2fs: use _safe() version of list_for_each
From: Namjae Jeon <linkinjeon@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: jaegeuk.kim@samsung.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/21, Dan Carpenter <dan.carpenter@oracle.com>:
> I sometimes write little user space programs to help me check my
> work.  I've attached one.
>
> gcc test.c
> ./a.out
>
> regards,
> dan carpenter
>
Hi Dan.
Thanks for testcase. I understand fully.
list_for_each still use pos after removing pos in loop. So, we need to
use _safe function to get pos->next safely.

Thanks.

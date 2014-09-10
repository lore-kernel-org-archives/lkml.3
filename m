Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaIJPHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:07:16 -0400
Received: from mail.ispras.ru ([83.149.199.45]:52635 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaIJPHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:07:14 -0400
Message-ID: <54106920.7000103@ispras.ru>
Date: Wed, 10 Sep 2014 19:07:12 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] [media] mceusb: fix usbdev leak
References: <1410214243-6319-1-git-send-email-khoroshilov@ispras.ru> <20140909103903.GA623@gofer.mess.org>
In-Reply-To: <20140909103903.GA623@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.2014 14:39, Sean Young wrote:
> On Tue, Sep 09, 2014 at 02:10:43AM +0400, Alexey Khoroshilov wrote:
>> mceusb_init_rc_dev() does usb_get_dev(), but there is no any
>> usb_put_dev() in the driver.
> drivers/media/rc/imon.c suffers from the same problem.
>
> Thanks
> Sean
Yes, our static analyzers show that as well.

We will prepare a patch soon, if nobody has done it yet.

Thanks,
Alexey

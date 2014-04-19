Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaDSIEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 04:04:43 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:55000 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaDSIEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 04:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140418232315.GA23165@kroah.com>
References: <1397843871-10850-1-git-send-email-prtvar.b@gmail.com>
	<20140418232315.GA23165@kroah.com>
Date: Sat, 19 Apr 2014 09:58:23 +0200
Message-ID: <CAOmT4fRoz+TyxUKBS22RAqsZmyo-27qCuKQQsg-hHdsY5JRSWw@mail.gmail.com>
Subject: Re: [PATCH] Staging: crystalhd: Mark local functions as static
From: bojan prtvar <prtvar.b@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: nsankar@broadcom.com, jarod@wilsonet.com, Scott Davilla <davilla@4pi.com>,
        Manu Abraham <abraham.manu@gmail.com>,
        Amarjargal G <amarjargal16@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 1:23 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Apr 18, 2014 at 07:57:51PM +0200, Bojan Prtvar wrote:
>> This fixes the following sparse warnings:
>> drivers/staging/crystalhd/crystalhd_lnx.c:631:5: warning: symbol 'chd_dec_pci_suspend' was not declared. Should it be static?
>> drivers/staging/crystalhd/crystalhd_lnx.c:665:5: warning: symbol 'chd_dec_pci_resume' was not declared. Should it be static?
>> drivers/staging/crystalhd/crystalhd_lnx.c:78:29: warning: symbol 'chd_dec_alloc_iodata' was not declared. Should it be static?
>> drivers/staging/crystalhd/crystalhd_lnx.c:99:6: warning: symbol 'chd_dec_free_iodata' was not declared. Should it be static?
>>
>> Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
>> ---
>>  drivers/staging/crystalhd/crystalhd_lnx.c |   10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> This patch doesn't apply to my tree, can you redo it and resend?
>
> thanks,
>
> greg k-h

I cloned your tree
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
and on master branch I see work is already done in

commit 038d3f882926bf49562e5f119957fd81015a9390
Author: Valentina Manea <valentina.manea.m@gmail.com>
Date:   Mon Oct 7 23:12:14 2013 +0300

Now what confuses me is the date of this patch. Why I didn't see it
linux-next and even in vanilla?
I know this question goes under 'basic workflow section'.

Regards,
Bojan

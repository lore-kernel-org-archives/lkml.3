Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab3BBTal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 14:30:41 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39905 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab3BBTaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 14:30:39 -0500
MIME-Version: 1.0
In-Reply-To: <CALF0-+XX27u4rmpe8RHiy5DsbHvoYP9DWQts+rTRfEvPQG4s8Q@mail.gmail.com>
References: <CALF0-+XX27u4rmpe8RHiy5DsbHvoYP9DWQts+rTRfEvPQG4s8Q@mail.gmail.com>
Date: Sat, 2 Feb 2013 16:30:37 -0300
Message-ID: <CALF0-+V-8m1TwnM0MUbNCncnECF_r_FVcyu_Duu0tqcsPoFR5A@mail.gmail.com>
Subject: Question about printking
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: gregkh <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>,
        kernel-janitors@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a quick question.
I (think I) remember Greg KH reviewing some driver patch on staging
mailing list,
suggesting not to do this sort of printking upon an allocation request failure:

ptr = kmalloc(sizeof(foo));
if (!ptr) {
        pr_err("Cannot allocate memory for foo\n");
        return -ENOMEM;
}

His argue against it was that kmalloc already takes care of reporting/printking
a good deal of interesting information when this happens.

Is my memory right?

Can someone expand a bit on this whole idea? (of abuse of printing,
or futility of printing).

I'm asking after seeing *a lot* of drivers doing exactly this.

Thanks,

--
    Ezequiel

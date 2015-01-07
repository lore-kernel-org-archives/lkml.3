Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbbAGM2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:28:14 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42433 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbAGM2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:28:13 -0500
MIME-Version: 1.0
In-Reply-To: <D0D2667E.D2C25%andreas.dilger@intel.com>
References: <CANZNk80SoQZU994psVKuuGRGGHnGgO7bcFpPBQoGyg=CjW77xw@mail.gmail.com>
	<20150107083654.GK15033@mwanda>
	<D0D2667E.D2C25%andreas.dilger@intel.com>
Date: Wed, 7 Jan 2015 14:28:12 +0200
Message-ID: <CANZNk83Y5T75H86VZ4dMVigPiaVADZB60yc6QWWCWdJ=SdT+sQ@mail.gmail.com>
Subject: Re: lustre/lnet/lnet/lib-move.c: memcpy with (struct
 iovec*)->iov_base, which is __user
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-07 13:32 GMT+02:00 Dilger, Andreas <andreas.dilger@intel.com>:
> On 2015/01/07, 1:36 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:
>> Didn't Al change these to kvec instead of iovec?  You have to look at
>> the callers to figure out if it's actually a user space pointer or a
>> kernel pointer.
>
> A patch was sent by Al on Dec 2 to replace iovec with kvec, in a thread
> titled "[PATCH] staging:lustre:lnet: Incorrect type in assignment".  Greg
> replied on Dec 10 in another thread (also fixing this same warning) titled
> "[PATCH] staging: lustre: Fix the warning messages about casting without
> __user macro" that Al's patch was in the staging tree for 3.19-rc1.

In current linux-next, I see none of the mentioned patches. Also I
don't see them mentioned in GKH's merge commit "Merge tag
'staging-3.19-rc1'..."
Is it ok?

-- 
Andrey Utkin

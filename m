Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaCCOwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:52:32 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:65143 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaCCOwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:52:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140301120129.GF26722@mwanda>
References: <CAFB2WuVNJY0wqGwg6c0M1pgx8P1h+3=UpGHW0=bxR65LSm3Edw@mail.gmail.com>
	<20140301120129.GF26722@mwanda>
Date: Mon, 3 Mar 2014 20:22:01 +0530
Message-ID: <CAFB2WuVNJCSAF6Mp95NqiFsmPRZbNCcc=0yvJoCFRSGXHU6mFA@mail.gmail.com>
Subject: Re: Staging driver: drivers/staging/vt6656/
From: Monam Agarwal <monamagarwal123@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: forest@alittletooquiet.net, Greg KH <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Andr=E9s_More?= <more.andres@gmail.com>,
        nandini h <nandu.hgowda@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 1, 2014 at 5:37 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Mar 01, 2014 at 03:37:17PM +0530, Monam Agarwal wrote:
>> Hello all,
>>
>> I have a confusion regarding functions in aes_ccmp.c. It seems none of
>> these functions are currently being used. So Is fine if we can remove
>> this file or should we keep it.
>
> Are you sure?  The first function I looked at was used.
>
> regards,
> dan carpenter
>

I did a build which asked me to declare variable as static. But on
declaring it as static it started giving me warnings of unused
function. However now i checked and functions seems to be used.

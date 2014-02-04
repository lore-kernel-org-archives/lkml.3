Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaBDIa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:30:28 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46319 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaBDIaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:30:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140204082317.GH26722@mwanda>
References: <1391497286-6951-1-git-send-email-sj38.park@gmail.com> <20140204082317.GH26722@mwanda>
From: SeongJae Park <sj38.park@gmail.com>
Date: Tue, 4 Feb 2014 17:29:50 +0900
Message-ID: <CAEjAshoKE+e2xXn+VRArz65Cb0bgznShXXQV_NYzJ1nve+pJRQ@mail.gmail.com>
Subject: Re: [PATCH] staging: cxt1e1: fix pointer-integer size mismatch warning
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, dulshani.gunawardhana89@gmail.com,
        shaun@xresource.ca, lisa@xenapiadmin.com, sima.baymani@gmail.com,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 5:23 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Feb 04, 2014 at 04:01:26PM +0900, SeongJae Park wrote:
>> Fix the pointer-integer size mismatch warning below:
>>       drivers/staging/cxt1e1/functions.c: In function ‘VMETRO_TRACE’:
>>       drivers/staging/cxt1e1/functions.c:268:21: warning: cast from pointer
>>                       to integer of different size [-Wpointer-to-int-cast]
>>            u_int32_t   y = (u_int32_t) x;
>>                            ^
>
> This function isn't called.  Just delete it from here and also from the
> .h file.
>

Nice review. Thank you for reviewing. I will upload new patch soon.

> regards,
> dan carpenter
>

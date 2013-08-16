Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3HPHkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:40:40 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:52740 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3HPHkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130816071338.GC26086@mwanda>
References: <1376595295-7820-1-git-send-email-jfrederich@gmail.com>
	<20130816071338.GC26086@mwanda>
Date: Fri, 16 Aug 2013 09:40:38 +0200
Message-ID: <CAF92urq-bL_y9zjt9THh-LJjxrMYmdjwr7RssgBk+zxC-OhRdQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] Staging: olpc_dcon: replace some magic numbers
From: Jens Frederich <jfrederich@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Jon Nettleton <jon.nettleton@gmail.com>, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 9:13 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, Aug 15, 2013 at 09:34:55PM +0200, Jens Frederich wrote:
>> The 0x42 initialize squence 0x101 is wrong.  According to
>> the specification Bit 8 is reserved, thus not in use.
>> I removed it.
>
> Really these code changes should be in a separate patch and labeled
> "Don't set reserved bit." instead of hidden away inside a cleanup
> patch.
>

The patch is applied. Still, good to know. It's not so easy to find the
right patch granularity as newbie.

Greg, what's your opinion, should I split the patch up?

thanks,
jens

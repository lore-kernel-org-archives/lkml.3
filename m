Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaIWQUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:20:21 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55699 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbaIWQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:19:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140919182221.0d8c2a92@sem.office.altlinux.ru>
References: <1411037700-28966-1-git-send-email-sem@altlinux.org>
	<20140918112206.GA26866@mguzik>
	<20140919182221.0d8c2a92@sem.office.altlinux.ru>
Date: Tue, 23 Sep 2014 18:19:06 +0200
Message-ID: <CAELBmZDEEwp1bH9FKBouy+q86u_KLHBth=JvGy_dVLN7bEbmkQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: Don't exchange filenames unconditionally.
From: Miklos Szeredi <miklos@szeredi.hu>
To: Mikhail Efremov <sem@altlinux.ru>
Cc: Mateusz Guzik <mguzik@redhat.com>, Mikhail Efremov <sem@altlinux.org>,
        LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 4:22 PM, Mikhail Efremov <sem@altlinux.ru> wrote:
> On Thu, 18 Sep 2014 13:22:07 +0200 Mateusz Guzik wrote:
>> On Thu, Sep 18, 2014 at 02:55:00PM +0400, Mikhail Efremov wrote:
>> > Only exchange source and destination filenames
>> > if flags contain RENAME_EXCHANGE.

Acked-by: Miklos Szeredi <mszeredi@suse.cz>


>>
>> But names are still exchanged without RENAME_EXCHANGE, provided they are
>> long enough.
>>
>> da1ce0670c14 introduced this behaviour also for short names and this is
>> what you are reverting here.
>>
>> That said, I think the patch is fine as an interim change, but should
>> note facts mentioned above.
>>
>> For more info please see https://lkml.org/lkml/2014/9/7/6
>
> Thanks for pointing out that thread to me, I didn't read it before
> sending the patch.
>
>> I'll be posting a RFC patch for actual problem next week.
>
> I suppose then that no sense to resend this patch right now, I'll just
> wait the proper solution from you.
> Yet this patch can be used as a temporary workaround (as you mentioned
> above) if the proper solution takes longer than expected to implement.

Yes, feel free to resend it to Linus, before 3.17 proper is out.

Also please consider adding:

Cc: stable@vger.kernel.org

Thanks,
Miklos

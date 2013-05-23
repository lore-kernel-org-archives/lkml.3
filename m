Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab3EWMNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:13:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53158 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158Ab3EWMN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <OF6992CC88.316C799B-ON48257B74.0040CED8-48257B74.0041FF6F@zte.com.cn>
References: <CAFLxGvxfzHudUMRc7VkgWMO9RJAkyh1iuouRAV-0s-5eaLqfEQ@mail.gmail.com>
	<OFE7F9663A.1F3DE1BE-ON48257B60.00045684-48257B60.001360DF@zte.com.cn>
	<CAFLxGvzKw1_L3Nm4J5GM_wr0sFe6umN0yLzDnK=DM_AJ7GpaaQ@mail.gmail.com>
	<OF6992CC88.316C799B-ON48257B74.0040CED8-48257B74.0041FF6F@zte.com.cn>
Date: Thu, 23 May 2013 14:13:27 +0200
Message-ID: <CAFLxGvw5gj-dfQeMKQVJpHPAXi4ZeNTaG3u3yXOAkshJRavXVA@mail.gmail.com>
Subject: Re: Re: Re: Re: [PATCH] UBI: fix memory leak when use fastmap
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: wang.bo116@zte.com.cn
Cc: cui.yunfeng@zte.com.cn, LKML <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        liu.dong3@zte.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 2:00 PM,  <wang.bo116@zte.com.cn> wrote:
> richard -rw- weinberger <richard.weinberger@gmail.com>  2013-05-13
> 16:08:35:
>
>>
>> I tried to apply/test your patch.
>> It has lots of white spaces damages.
>> Can you please resend it using git send-email?
>> And also run checkpatch.pl before sending.
>>
>> --
>> Thanks,
>> //richard
>
> hello:
>         I use git to remake a patch, and pass the checkpatch.pl's test.
> But my email client is lotus notes, and the patch's format may be damage
> by the client.

This explains the broken patch.
You can also send me the patch as attachment. :)

--
Thanks,
//richard

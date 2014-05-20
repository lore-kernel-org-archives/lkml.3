Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaETFJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:09:22 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:37581 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaETFJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140519190434.GS16255@mwanda>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
	<1400426361-19596-6-git-send-email-navin.patidar@gmail.com>
	<20140519105208.GV15585@mwanda>
	<CAPV97ydMiagwQqS6cAS_ck1+XOZWKH82okPG0V1fLcpsLKL8zg@mail.gmail.com>
	<20140519190434.GS16255@mwanda>
Date: Tue, 20 May 2014 10:39:19 +0530
Message-ID: <CAPV97ydnjC_Ojr_9JLRaJv+o5VFqZENFi5t_68MGR7rMq9XLag@mail.gmail.com>
Subject: Re: [PATCH 05/28] staging: rtl8188eu: Remove unused function rtl8188eu_ps_func()
From: navin patidar <navin.patidar@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:34 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Mon, May 19, 2014 at 09:19:07PM +0530, navin patidar wrote:
>> > You have changed it to return _FAIL instead of true.  Perhaps that is ok
>> > but you need to explain it in the changelog.
>> >
>> oops, I'll resend this patch with proper changelog.
>> I have one question, do i need to send v2 of whole patch series or
>> just this patch.
>
> Greg, none of the other patches rely on this one.  Could you apply them
> and drop this one?  This one is also fine except for the changelog but
> Navin can send a new version in a new thread.

Please drop this patch.

> [ General rules on redoing patches threads ]
>
> When you are sending a patch series and someone asks you to update one
> changelog, then you can resend just the patch but you must set the
> In-Reply-To email header.  You didn't do that for [PATCH 13/28] so now
> the v2 of that patch is in its own thread.

Okay, I'll keep that in mind next time.

>
> If you are sending a patch series and updating one in the middle means
> that the other patches won't apply then you should redo the whole thing
> or ask Greg to apply the first 7 patches and redo the last ones.
>
> If you are sending a series and you have to update a lot of patches then
> resend the whole thing because otherwise it becomes confusing.

Thanks for explaining the process in detail. :)

> [ This patch in particular ]
>
> Ok.  So I looked at this and the function which calls
> rtw_hal_intf_ps_func() is never called, so you're right that this
> function isn't used.  Probably this is what you were going to put in
> your changelog and I would check and that's fine.
>
> But when I am reviewing these kinds of "delete unused code" patches then
> I just "Ok.  If there are still users the compile will break."  So I
> don't have to look outside the email client.  So I would prefer if you
> did it in this order:
>
> [patch 1/4] staging: rtl8188eu: Remove unused function rtw_interface_ps_func()
> [patch 2/4] staging: rtl8188eu: Remove unused function rtw_hal_intf_ps_func()
> [patch 3/4] staging: rtl8188eu: Remove unused function pointer ->interface_ps_func
> [patch 4/4] staging: rtl8188eu: staging: rtl8188eu: Remove unused function rtl8188eu_ps_func()

I'll send new patchset in order you mentioned.

regards,
navin patidar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaESKZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:25:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbaESKZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:25:23 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Karim Raslan <karim.allah.ahmed@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au: rtw_sta_mgt: change rtw_alloc_stainfo23a to use gfp_t instead if int
References: <1400395256-8892-1-git-send-email-karim.allah.ahmed@gmail.com>
	<20140519101855.GU15585@mwanda>
Date: Mon, 19 May 2014 12:25:13 +0200
In-Reply-To: <20140519101855.GU15585@mwanda> (Dan Carpenter's message of "Mon,
	19 May 2014 13:18:56 +0300")
Message-ID: <wrfjtx8mrrp2.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:
> On Sun, May 18, 2014 at 07:39:23AM +0100, Karim Raslan wrote:
>> This should fix a few sparse warnings like the following:
>> 
>>   CHECK   drivers/staging/rtl8723au/core/rtw_ap.c
>> drivers/staging/rtl8723au/core/rtw_ap.c:1054:45: warning: incorrect
>> type in argument 3 (different base types)
>> drivers/staging/rtl8723au/core/rtw_ap.c:1054:45:    expected int [signed] gfp
>> drivers/staging/rtl8723au/core/rtw_ap.c:1054:45:    got restricted gfp_t
>> 
>
> Thanks, Karim, looks good.
>
> Jes's patch which added this never went to the list so I didn't review
> it.  This annoys me.
>
> I try to be fair when I review code.  I try to allow lots of patches in
> and let people send fix up patches for minor stuff.  But, obviously, you
> should be running Sparse as part of the review process so if I made you
> redo this patch it's because your process is broken.  When I review
> patches I am trying to help you.

Dan,

Calm down, I haven't been bombarding the list, due to the sheer volume
of commits.  If you want me to spam the list, tell me where and I'll add
that to the CC list next time.

This particular case isn't exactly a real problem either.

Jes

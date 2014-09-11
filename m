Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaIKXij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:38:39 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34043 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaIKXii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:38:38 -0400
Message-ID: <5412327B.6030000@lwfinger.net>
Date: Thu, 11 Sep 2014 18:38:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: repeated bugs in new rtl wifi drivers
References: <CAGXu5j+kh3TTR8yiyH35mXUo91g5a-ULS6w2CvKzGmQ4UuL-aA@mail.gmail.com>
In-Reply-To: <CAGXu5j+kh3TTR8yiyH35mXUo91g5a-ULS6w2CvKzGmQ4UuL-aA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 05:27 PM, Kees Cook wrote:
> Hi,
>
> I keep fixing this same bug that keeps showing up in the rtl wifi
> drivers. CL_PRINTF keeps getting redefined (incorrectly) instead of
> using a correctly fixed global. Is there a way to stop this from
> happening again?
>
> Here are the past three (identical) fixes I've landed:
> a3355a62673e2c4bd8617d2f07c8edee92a89b8d
> 037526f1ae7eeff5cf27ad790ebfe30303eeebe8
> 6437f51ec36af8ef1e3e2659439b35c37e5498e2
>
> And the buildbot report below seems to show there are more to be made. :)

Sorry that I missed your fix. I should have seen it come through Linville's 
list. I will push your fix through again.

We are in the process of unifying the in-house driver development at Realtek 
with what I have been doing in the kernel. Unfortunately, this will involve 
rather massive changes in all the codes. I am trying not to wipe out fixes such 
as this one, but I expect that others will slip through. Once this painful 
process is completed, maintaining the drivers should be a lot easier.

Larry






Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3ARBJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:09:35 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:51247 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3ARBJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:09:33 -0500
Message-ID: <50F8A0C9.6040705@linaro.org>
Date: Thu, 17 Jan 2013 17:09:29 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Colin Cross <ccross@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC][PATCH 0/3] staging: alarm-dev: Cleanups and compat_ioctl
 support (v2)
References: <1357947984-15611-1-git-send-email-john.stultz@linaro.org> <20130118004827.GB8897@kroah.com>
In-Reply-To: <20130118004827.GB8897@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 04:48 PM, Greg KH wrote:
> On Fri, Jan 11, 2013 at 03:46:21PM -0800, John Stultz wrote:
>> Here is the second revision at implementing compat_ioctl support for
>> Android's alarm-dev driver in staging.
>>
>> The first patch removes the pre-Android 1.0 _OLD ioctls, per Colin's
>> suggestion. Then the second patch does some refactoring to cleanup
>> and separate the copying of user data from the logic, and the final
>> patch adds the compat_ioctl support.
>>
>> I've tested this with a trivial unit test compiled for both 32bit
>> and 64bit on a x86_64 kernel, and it looks ok, but closer review
>> would be appreciated to make sure I didn't break anything.
>>
>> Additional feedback or thoughts would be welcome!
> These look fine to me, want me to apply them to my -next tree for 3.9?

Yea, sure. I was going to resend tomorrow without the RFC tag.

Colin, Arve: No objections?

thanks
-john

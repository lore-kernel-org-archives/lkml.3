Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3ARVcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:32:48 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63520 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3ARVcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <50F8A0C9.6040705@linaro.org>
References: <1357947984-15611-1-git-send-email-john.stultz@linaro.org>
	<20130118004827.GB8897@kroah.com>
	<50F8A0C9.6040705@linaro.org>
Date: Fri, 18 Jan 2013 13:32:46 -0800
Message-ID: <CAMP5XgejeqgPaeM=Pqus7O_KfsawP6kKWSDytcenb+gWwqOrfg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] staging: alarm-dev: Cleanups and compat_ioctl
 support (v2)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Colin Cross <ccross@google.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 5:09 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 01/17/2013 04:48 PM, Greg KH wrote:
>>
>> On Fri, Jan 11, 2013 at 03:46:21PM -0800, John Stultz wrote:
>>>
>>> Here is the second revision at implementing compat_ioctl support for
>>> Android's alarm-dev driver in staging.
>>>
>>> The first patch removes the pre-Android 1.0 _OLD ioctls, per Colin's
>>> suggestion. Then the second patch does some refactoring to cleanup
>>> and separate the copying of user data from the logic, and the final
>>> patch adds the compat_ioctl support.
>>>
>>> I've tested this with a trivial unit test compiled for both 32bit
>>> and 64bit on a x86_64 kernel, and it looks ok, but closer review
>>> would be appreciated to make sure I didn't break anything.
>>>
>>> Additional feedback or thoughts would be welcome!
>>
>> These look fine to me, want me to apply them to my -next tree for 3.9?
>
>
> Yea, sure. I was going to resend tomorrow without the RFC tag.
>
> Colin, Arve: No objections?
>

Looks OK to me, but have not tested them.

-- 
Arve Hjønnevåg

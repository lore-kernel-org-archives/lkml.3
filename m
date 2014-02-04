Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaBDUOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:14:42 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64207 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbaBDUOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:14:37 -0500
Message-ID: <52F14A29.4080600@linaro.org>
Date: Tue, 04 Feb 2014 12:14:33 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Greg Hackmann <ghackmann@google.com>,
        Prakash Kamliya <pkamliya@codeaurora.org>,
        Alistair Strachan <alistair.strachan@imgtec.com>,
        Todd Poynor <toddpoynor@google.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 00/16] [RFC] Staging updates from the Android tree
References: <1391451388-23906-1-git-send-email-john.stultz@linaro.org> <20140204020649.GA16532@kroah.com>
In-Reply-To: <20140204020649.GA16532@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 06:06 PM, Greg KH wrote:
> On Mon, Feb 03, 2014 at 10:16:12AM -0800, John Stultz wrote:
>> I recently went through the AOSP common.git android/3.10 tree to
>> try to pull fixes that haven't been submitted upstream. I've
>> cherry picked those patches and wanted to submit them here for
>> review, and for hopeful inclusion into staging for 3.15.
>>
>> In most cases the patches cherry-picked right over. In a few cases,
>> there were collisions due to trivial changes and cleanups like
>> spelling fixes. However, the "ion: Move shrinker out of heaps"
>> patch required more complicated merge, due to the shrinker api
>> change upstream in 3.12.  Things build and appear to work, but
>> I'd appreciate extra review there.
>>
>> Anyway, please let me know if there's any feedback or suggestions. 
> As this series is ordered, I can't take any of them for 3.14-final
> (patch 1 is a cleanup patch, not for 3.14.)

Right, I actually wasn't shooting for 3.14 at all with these.

> Care to make 2 series, one for things you feel should be in 3.14 (i.e.
> bugfixes), and the other for what can wait for 3.15 (i.e. uapi header
> file stuff)?

Yea, I'll see if I can split them up.

thanks for the feedback!
-john


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaBGRQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:16:51 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43378 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBGRQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:16:50 -0500
Message-ID: <52F514FE.705@linaro.org>
Date: Fri, 07 Feb 2014 09:16:46 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Greg Hackmann <ghackmann@google.com>,
        Prakash Kamliya <pkamliya@codeaurora.org>,
        Alistair Strachan <alistair.strachan@imgtec.com>,
        Todd Poynor <toddpoynor@google.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCHv2 0/7] Staging fixes from the Android tree (for 3.14)
References: <1391558920-31590-1-git-send-email-john.stultz@linaro.org> <20140207170350.GA18784@kroah.com>
In-Reply-To: <20140207170350.GA18784@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 09:03 AM, Greg KH wrote:
> On Tue, Feb 04, 2014 at 04:08:33PM -0800, John Stultz wrote:
>> I recently went through the AOSP common.git android/3.10 tree to
>> try to pull fixes that haven't been submitted upstream. I've
>> cherry picked those patches and submitted them for 3.15, but
>> Greg requested the bugfixes to be submitted by themselves for
>> 3.14.
>>
>> So here are the subset of changes that are bugfixes. There is
>> one additional patch here which I missed in my last submission,
>> but its a build warning fix, so I think its appropriate.
>>
>> If and when these are merged, I'll resubmit the rest of the
>> queue (which has grown further as of today) for 3.15.
>>
>> Anyway, please let me know if there's any feedback or suggestions.
> I seem to be missing patch 2/7 here.  Any idea where it went?

Huh. I see it in my lkml archive. The subject is:
[PATCH 2/7] staging: sync: Signal pt before sync_timeline object gets
destroyed

https://lkml.org/lkml/2014/2/4/738

Maybe check your spam folder? If you need I can bounce it to you again.

thanks
-john

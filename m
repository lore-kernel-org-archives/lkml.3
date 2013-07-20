Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3GTNur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 09:50:47 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:46573 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3GTNup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 09:50:45 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130720124731.GA10834@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com> <51EA73BC.8050901@kernel.org> <20130720124731.GA10834@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/15] iio: ti_am335x_adc: Add continuous mode take 2
From: Jonathan Cameron <jic23@kernel.org>
Date: Sat, 20 Jul 2013 14:50:39 +0100
To: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Message-ID: <a8f2c435-027a-473f-9ea0-71bfe4276c2b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Zubair Lutfullah :" <zubair.lutfullah@gmail.com> wrote:
>On Sat, Jul 20, 2013 at 12:25:48PM +0100, Jonathan Cameron wrote:
>> I am a little irritated by the mess we have here.  Russ has clearly
>done
>> a lot of fine work cleaning up the earlier patches.  As a result
>> we have a series of initial buggy patches and then a series of
>patches
>> fixing them again.
>
>Indeed.
>
>I had already merged a lot of minor bug fixes from Rachil into the main
>patch that adds continuous mode.
>
>But I kept Russ's ones separate because of authorship and history.
> 
>
>> Part 1.  Any fixes that are unconnected to the rest of the series. 
>These will
>>   then get sent upstream within this cycle.
>
>Understood. I'll send a small series that is disjoint and contains
>fixes for the existing driver.
>
>> Part 2. Feature add patch. Here that is basically a single patch
>adding the
>>   continous mode support.
>>
>> It is nice to maintain history and all but I would much rather have
>something
>> that is easy to review, with appropriate comments or if people will
>give
>> them, sign offs to reflect the various contributions.
>> 
>> Jonathan
>
>And then one patch for continuous mode with appropriate
>comments/sign-offs.
>
Excellent. Thanks for sorting these out.
>Thank-you
>Zubair Lutfullah
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab3AJU1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:27:51 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43509 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3AJU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:27:48 -0500
Message-ID: <50EF2441.7020507@linaro.org>
Date: Thu, 10 Jan 2013 12:27:45 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Miroslav Lichvar <mlichvar@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timers: Fix clock_adjtime to return timex data
 on success
References: <1357837922-1555-1-git-send-email-mlichvar@redhat.com> <20130110201205.GE2909@netboy.at.omicron.at>
In-Reply-To: <20130110201205.GE2909@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 12:12 PM, Richard Cochran wrote:
> On Thu, Jan 10, 2013 at 06:12:02PM +0100, Miroslav Lichvar wrote:
>> Copy the modified timex data back to the user also with positive return
>> values. This fixes reading of the CLOCK_REALTIME timex data when the
>> clock is in a non-zero state.
>>
>> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
>
> (Adding John Stultz on CC)

Just to clarify (the commit message makes it pretty hard to understand 
exactly what's going wrong), this is to handle the case where 
clock_adj() returns a non-zero time_state value (such as TIME_INS) ?

thanks
-john


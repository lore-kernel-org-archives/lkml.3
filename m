Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3LLWfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 17:35:25 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49022 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3LLWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 17:35:23 -0500
Message-ID: <52AA3A27.5010403@linaro.org>
Date: Thu, 12 Dec 2013 14:35:19 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Brecht Machiels <brecht@mos6581.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 41c7f74 rtc: Disable the alarm in the hardware (v2)
References: <20131201220343.2285b12ee1c1e54252dc7dd9@mos6581.org> <529CF1D5.6010406@linaro.org> <20131202211958.GE7380@pd.tnic> <l7ppbg$brg$1@ger.gmane.org> <52AA10F4.6070108@linaro.org> <52AA27C7.3090206@linaro.org> <20131212212454.GC30162@pd.tnic>
In-Reply-To: <20131212212454.GC30162@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 01:24 PM, Borislav Petkov wrote:
> On Thu, Dec 12, 2013 at 01:16:55PM -0800, John Stultz wrote:
>> Borislav: I'd like to add your tested by too, if you've had the
>> chance.
> Sorry John, I still see you on the todo list but haven't had a chance due to
> more pressing issues. :-\

Understood. I don't mean to add extra pressure here, just want to make
sure your testing effort doesn't go unrecognized.

> Tell you what: I'll try to find some time over the weekend to reinstall
> the box which has the issue and will give it a run. You could go ahead
> and commit it but keep it on top of a branch in case it needs to be
> reverted. :-)

Will do. Thanks again, I appreciate your extra effort!

thanks
-john

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3FDQPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:15:50 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50766 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3FDQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:15:48 -0400
Message-ID: <51AE12B2.5050504@linaro.org>
Date: Tue, 04 Jun 2013 09:15:46 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marcus Gelderie <redmnic@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel:time Export symbols of functions declared
 in linux/alarmtimer.h
References: <1370104746-20993-1-git-send-email-redmnic@gmail.com> <51ACECB2.40407@linaro.org> <20130604072455.GA4096@cantor.Speedport_W_503V_Typ_C> <20130604073140.GB4096@cantor.Speedport_W_503V_Typ_C>
In-Reply-To: <20130604073140.GB4096@cantor.Speedport_W_503V_Typ_C>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 12:32 AM, Marcus Gelderie wrote:
> On Mon, Jun 03, 2013 at 12:21:22PM -0700, John Stultz wrote:
>> These probably should be EXPORT_SYMBOL_GPL, no? Also there's a bunch of
>> new alarm functions that Todd Poynor that I have queued, which will
>> probably need similar.
>>
>> thanks
>> -john
> Opps, yes they should, thanks. I've corrected that.
>
> Your new alarm functions are not in the tree yet, are they? At least I didn't
> find them.
No, not yet.

Anyway, I went ahead and queued your patch and added the other exports.

thanks for the patch!
-john


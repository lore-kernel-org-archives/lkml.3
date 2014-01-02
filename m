Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000AbaABJkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 04:40:21 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:56548 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaABJkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:40:20 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <52C52592.1020101@free-electrons.com>
References: <1387820884-28140-1-git-send-email-alexandre.belloni@free-electrons.com> <1387820884-28140-5-git-send-email-alexandre.belloni@free-electrons.com> <52C426C7.8090706@kernel.org> <201401012031.52593.marex@denx.de> <52C52592.1020101@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCHv5 RESEND 4/4] iio: mxs-lradc: convert is_divided to a bitmap
From: Jonathan Cameron <jic23@kernel.org>
Date: Thu, 02 Jan 2014 09:40:07 +0000
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Marek Vasut <marex@denx.de>
CC: lars@metafoo.de, harald@ccbib.org, hector.palacios@digi.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <d325339d-2153-44a3-ac28-d59be68a4262@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
>On 01/01/2014 20:31, Marek Vasut wrote:
>> On Wednesday, January 01, 2014 at 03:31:35 PM, Jonathan Cameron
>wrote:
>>> On 23/12/13 17:48, Alexandre Belloni wrote:
>>>> mxs_lradc.is_divided was an unsigned long array. Convert it to a
>bitmap
>>>> to save some memory.
>>>>
>>>> Signed-off-by: Alexandre Belloni
><alexandre.belloni@free-electrons.com>
>>>
>>> Hi Alexandre,
>>>
>>> I've applied this patch, but would have prefered that you post this
>one
>>> in separate series. It is a perfectly valid cleanup, but introducing
>it
>>> late in a series leads to uneven reviewing.  Anyhow, as it's trivial
>and
>>> I doubt Marek will mind, I've applied it anyway in a new years burst
>of
>>> trying to clear the outstanding stuff in my in box ;)
>>>
>>> Applied to the togreg branch of iio.git
>>>
>>> Thanks,
>> 
>> I dont mind, thanks for geting these in. And happy new year to you
>guys :)
>
>Thanks Jonathan !
You are welcome.  Thanks for persevering.
>
>I wish everyone the best for this new year !
Indeed, happy new year to you too.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

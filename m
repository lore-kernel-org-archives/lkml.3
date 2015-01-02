Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbbABMOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 07:14:50 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:53496 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbABMOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 07:14:49 -0500
X-Greylist: delayed 71028 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2015 07:14:48 EST
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CACna6rxbGRdw7XSYvHAJGxJvMVwjVbAL4ynBM3m9rNggh7gCVQ@mail.gmail.com>
References: <1420127170-28421-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CACna6rznUcqGTK0t1k=kjn0NVLycq865780ozyB+VYu78d_BSg@mail.gmail.com>
	<CACna6rxbGRdw7XSYvHAJGxJvMVwjVbAL4ynBM3m9rNggh7gCVQ@mail.gmail.com>
Date: Fri, 2 Jan 2015 13:14:47 +0100
Message-ID: <CA+icZUWOXMEyobZkudW9BEfkaWFTXQL9XF26g7oJMCzt=4==6g@mail.gmail.com>
Subject: Re: [PATCH] net: wireless: b43legacy: radio.c: Remove unused function
From: Sedat Dilek <sedat.dilek@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2015 at 1:06 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 2 January 2015 at 13:05, Rafał Miłecki <zajec5@gmail.com> wrote:
>> On 1 January 2015 at 16:46, Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se> wrote:
>>> Remove the function b43legacy_radio_set_tx_iq() that is not used anywhere.
>>>
>>> This was partially found by using a static code analysis program called cppcheck.
>>
>> It seems to be for A-PHY based hardware (with 0x2060 radio id) which
>> is not handled by b43legacy. Should be safe to drop this code (we
>> won't likely need it).
>>
>> Ack
>
> For future, we prefix patches with just a driver name. So this could
> be simply called
> b43legacy: radio.c: Remove unused function
>

Alternatively...

"b43legacy: Remove unused function in radio.c"

BTW, as Arnd Bergmann pointed out [1] how did you test with cppcheck
to get such stuff?

- Sedat -

[1] https://lkml.org/lkml/2015/1/2/51

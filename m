Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaAICnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 21:43:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48820 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbaAICnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 21:43:24 -0500
Message-ID: <52CE0CC8.20500@infradead.org>
Date: Wed, 08 Jan 2014 18:43:20 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Laszlo Papp <lpapp@kde.org>, Mark Brown <broonie@kernel.org>
CC: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/regmap.h: fix a couple of typos
References: <1389201738-31406-1-git-send-email-lpapp@kde.org>	<20140108180747.GT31886@sirena.org.uk>	<CAOMwXhN8x0xHstrwsrxqXoE+n19TP=r1HJDCFOHs2O024HaY1w@mail.gmail.com>	<20140108190758.GY31886@sirena.org.uk>	<CAOMwXhMh6A8wZa3rtQHH1HpYU6PoZuWkPuSki64hOAnAZ-QZoQ@mail.gmail.com>	<CAOMwXhNLN-gDHt=UKmmbA0VM1f6PnjcZWkZSDncemVZuxEGF1Q@mail.gmail.com>	<20140108214906.GB31886@sirena.org.uk> <CAOMwXhNsuG-s7z2xfZK9-qGPWNoyuE_1x3pSmz6CC2qyiituLA@mail.gmail.com>
In-Reply-To: <CAOMwXhNsuG-s7z2xfZK9-qGPWNoyuE_1x3pSmz6CC2qyiituLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 17:46, Laszlo Papp wrote:
> On Wed, Jan 8, 2014 at 9:49 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Wed, Jan 08, 2014 at 09:08:44PM +0000, Laszlo Papp wrote:
>>> On Wed, Jan 8, 2014 at 9:02 PM, Laszlo Papp <lpapp@kde.org> wrote:
>>
>>>> That being said, I will not have time, nor the motivation to argue
>>>> over such a nuance, so feel free to reject the change.
>>
>>> Of course, this is just on top of the vim spell checker error as I
>>> wrote in the commit message...
>>
>>> Oh yes, and one more factual data in here:
>>
>>> lpapp ~/Projects/linux-staging $ grep -rn "e\.g\." . | wc -l
>>> 3447
>>
>>> lpapp ~/Projects/linux-staging $ grep -rn " eg," | wc -l
>>> 18
>>
>> That's not the issue - it's dropping the comma.  It's either "e.g." or
>> "eg", the comma is a separate thing providing a break between clauses.
>> Strictly it should have the periods since it is an abbreviation but
>> their use is more vauge in fixed point text since they look ugly, the
>> thing that made me complain was that you dropped the comma as well as
>> substituting in the expanded version.
> 
> I still do not get what point you are trying to make. Could you please
> provide evidence? Because really, this is the usage I have seen in
> projects out there all around, including the majority of the linux
> kernel.
> 
> Here is some more data:
> 
> grep -rn "e\.g\. " . | wc -l
> 2553
> lpapp ~/Projects/linux-staging $ grep -rn "e\.g\.," . | wc -l
> 573
> --

Hi,

I am used to seeing e.g. and i.e. always followed by a comma when they are
used to begin a sentence.  However, I just checked and some online style
guides say to omit the comma and some say to use it, and we (Linux kernel)
don't really have a writing style guide to look at.  I think that makes it
up to the maintainer to decide what is acceptable.


-- 
~Randy

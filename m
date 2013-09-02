Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab3IBXqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 19:46:23 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49747 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3IBXqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:46:22 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5225234A.50407@roeck-us.net>
Date: Mon, 02 Sep 2013 16:46:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com> <1378161032.32763.341.camel@haakon3.risingtidesystems.com> <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
In-Reply-To: <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 03:50 PM, Linus Torvalds wrote:
> On Mon, Sep 2, 2013 at 3:30 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
>>
>> Unfortunately, this doesn't include the remaining target fixes for
>> v3.11:
>>
>> Re: [GIT PULL -v2] target fixes for v3.11
>> http://marc.info/?l=linux-kernel&m=137799048226191&w=2
>>
>> Is there a reason why these did not get PULLed..?
>
> Very simple: I have no such email in my mailbox. I see the "target
> updates for v3.11-rc1" email (and I pulled that), and there is nothing
> since.
>
> I don't even have that mail in my lkml archives, much less as a private email.
>
> I see neither youe "-v2 PULL request" nor the "One more late v3.11
> specific regression" one. In fact, I see no emails from you at all
> from Aug 31.
>
> It may be that gmail hates you for some reason...
>
> [ time passes ]
>
> Yup. It's in my spam-box, with gmail helpfully telling me:
>
>     Why is this message in Spam? We've found that lots of messages from
> linux-iscsi.org are spam.  Learn more
>
> so something is rotten in the state of linux-iscsi.org.
>
> Recent messages from you were similarly tagged:
>
>   "[GIT PULL -v2] target fixes for 3.11"
>   "Re: LIO FC Target"
>   "Re: [GIT PULL] target fixes for v3.11-rc7"
>
> there might have been more. You might want to try to figure out why
> gmail thinks that linux-iscsi.org is spammy.
>

I don't think it has anything to do with linux-iscsi.org.
Possibly Nicholas' e-mail provider is not hosted in the US, meaning e-mail
sent through it can not be logged and examined by a certain US government agency.

I had the same experience; Google blocks all e-mail from my private provider
(located in Singapore). When asked by the provider, they claimed to know
nothing about it. No, my provider doesn't forward more spam than other providers,
and definitely less than, say, Yahoo.

I can only recommend for everyone to send pull requests through a gmail account.
If you set it up correctly, you can keep using your non-gmail source address
but still send it through a Google server. Just don't use it for anything else
unless you don't mind Big Brother listening in.

Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaGISxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:53:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:60826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbaGISxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:53:09 -0400
Message-ID: <53BD8F8E.9030105@infradead.org>
Date: Wed, 09 Jul 2014 11:53:02 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Nick Krause <xerofoify@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: Fwd: linux-next: Tree for Jul 9
References: <20140709183116.506ad2e4@canb.auug.org.au> <CAPDOMVjAMHOhuzfcJRL_JQ1jSKOeE7PEhppZJKJKbtR2-ixi-A@mail.gmail.com> <53BD77CC.9060606@infradead.org> <20140709184703.GA16363@roeck-us.net>
In-Reply-To: <20140709184703.GA16363@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 11:47 AM, Guenter Roeck wrote:
> On Wed, Jul 09, 2014 at 10:11:40AM -0700, Randy Dunlap wrote:
>> On 07/09/2014 10:07 AM, Nick Krause wrote:
>>> ---------- Forwarded message ----------
>>> From: Stephen Rothwell wrote on Wed, Jul 9, 2014 at 4:31 AM
>>> Subject: linux-next: Tree for Jul 9
>>> To: linux-next@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>>
>>>
>>> Hi all,
>>>
>>> Changes since 20140708:
>>>
>>>
>>> --
>>> Cheers,
>>> Stephen Rothwell                    sfr@canb.auug.org.au
>>>
>>> Hey Stephen,
>>>
>>> A lot of your builds that are failing seem to build for me. Please try
>>> a compiler toolchain
>>> newer then gcc 4.6.3 to see if this is why your builds are failing.
>>> Since all the arm builds
>>> you have failing build for me.
>>> Cheers Nick
>>>
>>
>> Hey Nick,
>>
>> Does your email client interface have a "Reply All" or "Reply to All" button
>> or selection that you can use?  Please use that instead of Forwarding each message.
>> That will make it easier to read the email threading.
>>
> I suspect he may be using an e-mail client from a certain vendor in Redmond, WA.
> It appears they have not heard that there is something like '>' to mark original
> text in e-mail replies.

He used Reply one time and then reverted back to his old ways.

Nick, the idea is to use Reply all the time, not just one time.
That is, if you want to do things correctly and are not just wasting our time.

-- 
~Randy

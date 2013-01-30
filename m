Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3A3XM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 18:12:56 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49499 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3A3XMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 18:12:54 -0500
Message-ID: <5109A8F1.9040707@suse.cz>
Date: Thu, 31 Jan 2013 00:12:49 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <2240511.0oyl5pIt1j@vostro.rjw.lan> <51099BE2.5090706@suse.cz> <3120802.QvTiDSHyPj@vostro.rjw.lan>
In-Reply-To: <3120802.QvTiDSHyPj@vostro.rjw.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 11:45 PM, Rafael J. Wysocki wrote:
> On Wednesday, January 30, 2013 11:17:06 PM Jiri Slaby wrote:
>> On 01/30/2013 10:39 PM, Rafael J. Wysocki wrote:
>>>> What is cool is that I have steps to reproduce:
>>>> 1) boot
>>>> 2) run the attached script (turn on all possible power savings -- in
>>>> fact everything what powertop suggests)
>>>> 3) suspend to _disk_ (mem is not enough, BIOS apparently has to
>>>> interfere here)
>>>
>>> No, I don't think it's the BIOS.  Most likely the boot kernel.
>>
>> Or that...
>>
>>>> 4) resume from disk
>>>> 5) boom
>>>>
>>>> I tried to remove also wireless drivers, no change.
>>>
>>> Is the resume boot kernel the same as the one in the image?
>>
>> Yeah, the same ones: 3.7.5
> 
> Well, I guess that we leak some state from the boot kernel to the image kernel.
> I have no idea what it is, but I suspect something arch-specific.
> 
> I wonder what the affected systems have in common apart from e1000e?

Everything as I have thinkpad x230 too :). Is there any other report
than Borislav's?

I think I will start with commenting parts of `power' script to see
exactly which of the power savings cause this.

-- 
js
suse labs

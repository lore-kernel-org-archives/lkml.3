Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab3A3WRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 17:17:16 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39337 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab3A3WRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:17:12 -0500
Message-ID: <51099BE2.5090706@suse.cz>
Date: Wed, 30 Jan 2013 23:17:06 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <20130130200041.GD23895@pd.tnic> <51098397.5040206@suse.cz> <2240511.0oyl5pIt1j@vostro.rjw.lan>
In-Reply-To: <2240511.0oyl5pIt1j@vostro.rjw.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 10:39 PM, Rafael J. Wysocki wrote:
>> What is cool is that I have steps to reproduce:
>> 1) boot
>> 2) run the attached script (turn on all possible power savings -- in
>> fact everything what powertop suggests)
>> 3) suspend to _disk_ (mem is not enough, BIOS apparently has to
>> interfere here)
> 
> No, I don't think it's the BIOS.  Most likely the boot kernel.

Or that...

>> 4) resume from disk
>> 5) boom
>>
>> I tried to remove also wireless drivers, no change.
> 
> Is the resume boot kernel the same as the one in the image?

Yeah, the same ones: 3.7.5

-- 
js
suse labs

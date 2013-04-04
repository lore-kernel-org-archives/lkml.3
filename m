Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab3DDHcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:32:14 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50963 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab3DDHcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:32:13 -0400
Message-ID: <515D2C79.7040904@suse.cz>
Date: Thu, 04 Apr 2013 09:32:09 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <5109A8F1.9040707@suse.cz> <5109B11C.2010400@suse.cz> <5170962.qHnbnlVDfx@vostro.rjw.lan> <20130131070926.GC4926@pd.tnic> <510A2B1C.1060108@suse.cz> <20130131131805.GG4926@pd.tnic> <20130131132400.GH4926@pd.tnic> <5130A55E.8030508@suse.cz>
In-Reply-To: <5130A55E.8030508@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 01:55 PM, Jiri Slaby wrote:
> On 01/31/2013 02:24 PM, Borislav Petkov wrote:
>> On Thu, Jan 31, 2013 at 02:18:05PM +0100, Borislav Petkov wrote:
>>>> And if I pass nmi_watchdog=0 to the image kernel, it should be gone I
>>>> guess.
>>>
>>> How do you pass options the image kernel?
>>
>> Yep, passing "nmi_watchdog=0" to the kernel (both when you boot and
>> when you resume) fixes the issue - no more unknown NMIs. Did only 3 s/r
>> cycles though.
> 
> FWIW the last time I saw the unhandled NMI was on 31st Jan. Since I
> disabled NMI watchdog no more unhandled NMIs. I have to add that I don't
> use ethernet at all.

And yesterday I plugged in an ethernet cable for a wihle and guess what
happened today:
Uhhuh. NMI received for unknown reason 2c on CPU 0.

Still holds that this is the first time since Jan.

-- 
js
suse labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaLOKGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:06:18 -0500
Received: from out-mta21.ai270.net ([94.126.40.165]:46770 "EHLO
	out-mta10.ai270.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751313AbaLOKGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:06:14 -0500
Message-ID: <548EB292.4080801@iee.org>
Date: Mon, 15 Dec 2014 10:06:10 +0000
From: Richard Farthing <rfarthing@iee.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel boot panic 3.12-34 > 3.12.35
References: <548DAFA0.1090700@iee.org> <20141214182518.GA607@pd.tnic> <548EA9B5.70602@suse.cz>
In-Reply-To: <548EA9B5.70602@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AI-Sender: rf@keynet-technology.com
X-Bayes-Prob: 0.0001 (Score 0, tokens from: LCNPOST, base:default, @@RPTN)
X-Spam-Score: 0.00 () [Hold at 5.50] 
X-CanIt-Geo: ip=94.126.40.131; country=GB; region=Hertfordshire; city=Stevenage; latitude=51.9301; longitude=-0.1706; http://maps.google.com/maps?q=51.9301,-0.1706&z=6
X-CanItPRO-Stream: base:LCNPOST (inherits from base:default)
X-Canit-Stats-ID: 03NrK6bBH - 08b336fe1b75 - 20141215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I installed the kernel via YAST2 which makes and installs the initrd 
too, and have done this many times before on this test machine, so it 
seems unlikely to be my mistake, but it's always possible!  I will have 
a look at it again

Richard


On 15/12/2014 09:28, Jiri Slaby wrote:
> On 12/14/2014, 07:25 PM, Borislav Petkov wrote:
>> On Sun, Dec 14, 2014 at 03:41:20PM +0000, Richard Farthing wrote:
>>> I patched 3.12.34 to 3.12.35 and the attached now happens at boot.
>>> Sorry I don't have better than a photo, cannot get past this.
>>>
>>> The root FS is EXT2.  It's admittedly an old test machine that I'm using to
>>> build up a new configuration, so the  BIOS is a bit old, but it's at least
>>> dual core, not totally ancient.
>>>
>>> Let me know if you need more diagnostic
>> That happens very early and the first oops which is the most
>> relevant one is cut off and one cannot see what the bug actually is,
>> unfortunately.
>>
>> Can you catch dmesg of that boot over serial or netconsole or so? Ask if
>> you don't know how.
>>
>> You could send your .config, maybe it is reproducible in kvm. Also, can
>> you send a full dmesg of the successful boot with 3.12.34?
> Hmm...
>
> panic from mount_block_root?
>
> That would be:
> "VFS: Unable to mount root fs on %s"
>
> Did you use proper root= kernel parameter? Do you have initrd properly
> created and installed?
>
> thanks,


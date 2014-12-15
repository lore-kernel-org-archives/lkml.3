Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaLOJ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:28:26 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40163 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaLOJ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:28:24 -0500
Message-ID: <548EA9B5.70602@suse.cz>
Date: Mon, 15 Dec 2014 10:28:21 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Richard Farthing <rfarthing@iee.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel boot panic 3.12-34 > 3.12.35
References: <548DAFA0.1090700@iee.org> <20141214182518.GA607@pd.tnic>
In-Reply-To: <20141214182518.GA607@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2014, 07:25 PM, Borislav Petkov wrote:
> On Sun, Dec 14, 2014 at 03:41:20PM +0000, Richard Farthing wrote:
>> I patched 3.12.34 to 3.12.35 and the attached now happens at boot.
>> Sorry I don't have better than a photo, cannot get past this.
>>
>> The root FS is EXT2.  It's admittedly an old test machine that I'm using to
>> build up a new configuration, so the  BIOS is a bit old, but it's at least
>> dual core, not totally ancient.
>>
>> Let me know if you need more diagnostic
> 
> That happens very early and the first oops which is the most
> relevant one is cut off and one cannot see what the bug actually is,
> unfortunately.
> 
> Can you catch dmesg of that boot over serial or netconsole or so? Ask if
> you don't know how.
> 
> You could send your .config, maybe it is reproducible in kvm. Also, can
> you send a full dmesg of the successful boot with 3.12.34?

Hmm...

panic from mount_block_root?

That would be:
"VFS: Unable to mount root fs on %s"

Did you use proper root= kernel parameter? Do you have initrd properly
created and installed?

thanks,
-- 
js
suse labs

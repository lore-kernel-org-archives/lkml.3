Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaBMBvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:51:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55761 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaBMBvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:51:47 -0500
Message-ID: <52FC2531.9000304@infradead.org>
Date: Wed, 12 Feb 2014 17:51:45 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>, linux-kernel@vger.kernel.org
Subject: Re: i386_defconfig for 3.13.2?
References: <201402121408.12535.gheskett@wdtv.com>
In-Reply-To: <201402121408.12535.gheskett@wdtv.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 11:08 AM, Gene Heskett wrote:
> Greetings, not making any progress on newer kernel builds yet.
> 
> So I unpacked 3.13.2 this morning and copied its arch/x86/i386_defconfig to  
> .config.
> 
> Ran make oldconfig, then 3 or 4 sessions of xconfig removing stuff that 
> isn't for my hardware & generally making lots of modules where I wasn't 
> sure.
> 
> But, my "makeit" script, when it makes the initrd, spits out this, and note 
> the not always final "/"
> 
> now making a new /boot/initrd.3.13.2.img
> find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
> find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
> find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
> 
> And indeed that directory does not exist.
> And that string does not exist in the .config.
> 
> Does this ring any bells?

Not for me, but building the initrd (or initramfs) may be distro-specific.
You might have to share the command that was used for that and maybe even
the script that was executed (like /sbin/mkinitrd -- where yours and mine
are probably different depending on distros).

Have you (your script) already run 'make install' at this point?
AFAIK, that should have created /lib/modules/3.13.2/kernel/arch/ and some other
subdirectories there.


-- 
~Randy

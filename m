Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3L2L1O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 06:27:14 -0500
Received: from mail.wdtv.com ([66.118.69.84]:58891 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab3L2L1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 06:27:12 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: Git puzzle
Date: Sun, 29 Dec 2013 06:26:57 -0500
Cc: linux-kernel@vger.kernel.org
References: <201312282141.40725.gheskett@wdtv.com> <201312290127.05858.gheskett@wdtv.com> <20131229064707.GP19878@titan.lakedaemon.net>
In-Reply-To: <20131229064707.GP19878@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312290626.57318.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 December 2013, Jason Cooper wrote:
>On Sun, Dec 29, 2013 at 01:27:05AM -0500, Gene Heskett wrote:
>> On Sunday 29 December 2013, Jason Cooper wrote:
>...
>
>> >You may want to try the opposite approach.  x86_64_defconfig, then add
>> >just what is necessary to boot and reproduce the bug.
>> 
>> Did that, then added some stuff for my hdwe, made sure the Makefile
>> version and my makeit script versions matched. Fired off my
>> build/install script, But it bailed out at the mkinitramfs stage,
>> couldn't find
>> /lib/modules/3.8.2 because it was named "3.8.2+".
>
>For this bisect run, can you do without the initramfs?  Just build the
>sata driver and the fs driver into the kernel.  You may want to drop
>makeit and just do the bare minimum, 'make bzImage && make modules &&
>make modules_install' or similar.
>
>The '+' means the kernel build system (using git) determined that there
>were changes to the source tree from the most recent tagged version.  If
>there weren't, it would just use the tag 3.8.2.  You can take a look at
>scripts/setlocalversion to see how it figures it out.
>
>hth,
>
>Jason.
Up, leg cramps, the wet ram ain't the only thing old.  Anyway did that, 
copied the vmlinix to /boot/vmlinuz-3.8.2+, update-grub, reboot, selected 
it, got invalid magic numbers.  So I'm back on 3.12.6.  But when I went to 
make sure that 3.8.2 worked, my script had screwed that up thinking it was 
building a real, from tarball 3.8.2.  But I have that tree untouched so it 
will re-install. Which I will start and go back to bed.

Next?

Thanks.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

The inclusion of any link does not imply endorsement of the site.
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.

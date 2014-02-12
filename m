Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaBLTIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:08:15 -0500
Received: from mail.wdtv.com ([66.118.69.84]:51267 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaBLTIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:08:14 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: i386_defconfig for 3.13.2?
Date: Wed, 12 Feb 2014 14:08:12 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402121408.12535.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings, not making any progress on newer kernel builds yet.

So I unpacked 3.13.2 this morning and copied its arch/x86/i386_defconfig to  
.config.

Ran make oldconfig, then 3 or 4 sessions of xconfig removing stuff that 
isn't for my hardware & generally making lots of modules where I wasn't 
sure.

But, my "makeit" script, when it makes the initrd, spits out this, and note 
the not always final "/"

now making a new /boot/initrd.3.13.2.img
find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
find: `/lib/modules/3.13.2/kernel/arch': No such file or directory
find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory
find: `/lib/modules/3.13.2/kernel/arch/': No such file or directory

And indeed that directory does not exist.
And that string does not exist in the .config.

Does this ring any bells?

Thanks.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.


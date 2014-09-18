Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaIRMAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:00:09 -0400
Received: from mail.wdtv.com ([66.118.69.84]:56666 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaIRMAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:00:08 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel version problem after patching
Date: Thu, 18 Sep 2014 08:00:01 -0400
References: <N1R-QFWRbm96u9@Safe-mail.net>
In-Reply-To: <N1R-QFWRbm96u9@Safe-mail.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201409180800.01376.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2014, r02@safe-mail.net wrote:
>There is a kernel version problem after patching the kernel. After
>installing the kernel and the kernel modules, without patching the
>kernel, then "uname" shows the right kernel version and in
>"/lib/modules/" there was the right directory created.
>
>But after patching the kernel, installing it and the modules, then the
>kernelversion shown with "uname" and the modules directory in
>"/lib/modules/" is not correct anymore.
>
>For example:
>If i download the kernel 3.14.19, patch it, and install the kernel and
>the modules then "uname" shows kernel version 3.14.0 and the modules
>are installed in "/lib/modules/3.14.0/" instead of 3.14.19 which would
>be the correct version.
>
>The same problem happens with other kernel versions too below 3.14.19
>and also to kernel version 3.16.3 and versions below. But probably much
>more kernel versions are affected from this problem.
>
>If someone has an older kernel installed correctly, 3.16 for example,
>and wants to install a patched second kernel, 3.16.3 for example, then
>the modules directory of the first one will be overwritten unwanted due
>to this version error because both kernels have the same modules
>directory "/lib/modules/3.16.0".

I got bit by that when I built the tarball of 3.1.6.0 the first time, it 
all went into 3.16.  The .0 was missing in the tarballs Makefile.  And, 
that is how it unpacked from the tarball too.

Cheers, Gene Heskett
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>
US V Castleman, SCOTUS, Mar 2014 is grounds for Impeaching SCOTUS

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbaJHN6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:58:32 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53215 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbaJHN6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:58:31 -0400
MIME-Version: 1.0
Message-ID: <trinity-253b1e32-44e3-400a-82b3-1c78f5446adf-1412776709482@3capp-1and1-bs01>
From: e40@online.de
To: linux-kernel@vger.kernel.org
Subject: Re: kernel version problem after patching
Content-Type: text/plain; charset=UTF-8
Date: Wed, 8 Oct 2014 15:58:29 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K0:NDBl/ac4HW9wc1joV5g8vhZ99t0JhnHPVHXP7Y2ywXP
 ZAY40+ECr+e5UMJ2e+3CE1rmI2L+AXwCUkRQvNMt8CBQqr5wNG
 HsD3EWfkJFQKKiO8X3YF9QLJqwiXQoaZ353pIkdS+NRCPL61c2
 eGl9wFulm5PFGjqaWJQx2Ow4bBQlz2dgnkf7MVMiass1uk0QwI
 uV4PfWxkjq6tU93TiRr3N4nU7q86lb3vO8WpapCgECA+qy3/qR
 1ihS4xwfkhRDzWdf/7rEsF6byBBIo6b+c551e9Pz9AEBfKtrBu qNbQuU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  
To solve this error you have to edit the "Makefile" inside the 
main kernel directory after you have patched the kernel.

At the beginning of the "Makefile" there are three variables
which can contain wrong values after patching. These are:
"PATCHLEVEL", "SUBLEVEL" and "EXTRAVERSION".

 ---

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
 

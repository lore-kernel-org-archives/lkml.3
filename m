Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaIRLu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:50:57 -0400
Received: from rimon.safe-mail.net ([212.29.227.68]:55442 "EHLO
	rimon.safe-mail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaIRLuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:50:55 -0400
X-Greylist: delayed 961 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 07:50:55 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
	s=N1-0105; d=Safe-mail.net;
	b=DLnfY4k51G6yWFb1JFOfLZm7t5pB/D47rKqIkiaoOmMlFEK5mTg027/K2dB5kFMj
	6OFqfjMYIGdf4CL4rOF1IeW3zJBDu1a3Sz1rZY0jeE8HrzqIZsB2u6c2wSrofwT+
	FWdHDhZHyl3IToA8oG6NO8pJ1gTzrIhx7nQGrnR7zHc=;
Subject: kernel version problem after patching
Date: Thu, 18 Sep 2014 07:34:49 -0400
From: r02@Safe-mail.net
To: linux-kernel@vger.kernel.org
X-SMType: Regular
X-SMRef: N1R-QFWRbm96u9
Message-Id: <N1R-QFWRbm96u9@Safe-mail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-SMSignature: 0BMkg3dcRHWbWP8ePdUKZ8rRqGZpBe7mDQdMQ8W39O9FVZVxhDxxHzeYuXMd3Wvn
	U88pQ+jj53lGAjZ9zHhq8GKmrTE9a8uAIXYGsk9DxuJgS0Btio2ltUjjkBh5NiuU
	vHtlCP7n4LtNL++N6zHUTfHCGX7SkBtmZy+37b/ELtQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a kernel version problem after patching the kernel. After
installing the kernel and the kernel modules, without patching the kernel,
then "uname" shows the right kernel version and in "/lib/modules/" there
was the right directory created. 

But after patching the kernel, installing it and the modules, then the 
kernelversion shown with "uname" and the modules directory in 
"/lib/modules/" is not correct anymore. 

For example: 
If i download the kernel 3.14.19, patch it, and install the kernel and the
modules then "uname" shows kernel version 3.14.0 and the modules are
installed in "/lib/modules/3.14.0/" instead of 3.14.19 which would be the
correct version.

The same problem happens with other kernel versions too below 3.14.19 and
also to kernel version 3.16.3 and versions below. But probably much more
kernel versions are affected from this problem.

If someone has an older kernel installed correctly, 3.16 for example, and
wants to install a patched second kernel, 3.16.3 for example, then the
modules directory of the first one will be overwritten unwanted due to
this version error because both kernels have the same modules directory
"/lib/modules/3.16.0".

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaFABnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 21:43:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41878 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbaFABnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 21:43:06 -0400
Date: Sun, 1 Jun 2014 01:43:01 +0000
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: Licensing & copyright of kernel .config files (defconfig, *config)
Message-ID: <robbat2-20140601T012929-356267352Z@orbis-terrarum.net>
Reply-To: linux-kernel@vger.kernel.org, robbat2@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please CC me on replies, not subscribed to LKML)

Hi,

Somewhat of an odd question, but none of the files in question seem to
have a copyright header on them...

For a kernel .config file, either from one of the defconfig or any other
*config option that automates the answer:
1. What license does the file fall under?
2. Who are the copyright holders?

Naively, since the defconfigs are bundled with the kernel, that could
fall under GPLv2-only implicitly, but lacking any explicit copyright
headers makes this interesting (arch/*/configs/* contain lots of files,
no copyright headers on them).

If I manually write the names of some configuration options to a new
.config file, at that point I logically am the only author and have
copyright of it. My editor slaps a default license on it of BSD-2.
Thereafter I run olddefconfig, and now it's a combined work of the
kernel's defconfig and my manual settings. If GPL-2 was inherited from
the kernel tree, this is now a combined BSD-GPL2 work, or is it? The
kernel config tools did consider my file as input, possibly overrode the
settings if they didn't work with others, and re-output everything.

If the files are to be marked with a copyright header, who is the holder
of it that it should be attributed to?

Alternatively, is this a case where the work is not copyrightable, and
the files should have a notice to that effect?

Background:
Gentoo has a bunch of "stock" kernel configurations for release
engineering, our initramfs tool (genkernel), and other endeavors over
the years. These projects claim BSD, GPL2, LGPL2 on various pieces, and
I don't think they can all be correct. I'm working on getting them into
one place, because some of them have been getting stale, but the
differing licenses raised a red flag to me.

-- 
Robin Hugh Johnson
Gentoo Linux: Developer, Infrastructure Lead
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11ACBA4F 4778E3F6 E4EDF38E B27B944E 34884E85

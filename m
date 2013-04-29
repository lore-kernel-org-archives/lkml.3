Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3D2Ioq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:44:46 -0400
Received: from awesome.dsw2k3.info ([195.71.86.230]:40425 "EHLO
	awesome.dsw2k3.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3D2Iop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:44:45 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 04:44:45 EDT
Date: Mon, 29 Apr 2013 10:36:49 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Build-failure with old files in build-directory (Was: Linux 3.9
 released)
Message-ID: <20130429083649.GA23540@citd.de>
References: <CA+55aFxcqR+5wK0QoGBA_jYP1epH2NCbVTRaE51rLK3mdRjN6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxcqR+5wK0QoGBA_jYP1epH2NCbVTRaE51rLK3mdRjN6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.04.2013 17:56, Linus Torvalds wrote:

I'm not sure if it is supported, but building with a O= -directory that 
was previously used to build a 3.8.9-kernel that was "clean"ed (but not 
"mrproper"ed) before building 3.9 results in a build-failure:
make[2]: *** No rule to make target `/xssd/usr_src/ko/leeloo/include/config/hz.h', needed by `kernel/hz.bc'.  Stop.

After deleting everything in the KBUILD_OUTPUT-directory, except the 
.config-file, the kernel-build worked again.

At least in the past a "clean" seamed to be enough. I had a file with a 
2.6.39-name inside, so it seams i have build my kernels this way for the 
last few releases.





-- 

Matthias

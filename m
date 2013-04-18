Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3DRSG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:06:56 -0400
Received: from plane.gmane.org ([80.91.229.3]:57153 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3DRSGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:06:55 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Akemi Yagi <amyagi@gmail.com>
Subject: Re: Error in linux-3.0.73 build
Date: Thu, 18 Apr 2013 18:06:31 +0000 (UTC)
Message-ID: <kkpcn6$bq2$1@ger.gmane.org>
References: <kkcvac$618$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: energy.scripps.edu
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Apr 2013 01:04:12 +0000, Akemi Yagi wrote:

> Just tried to build from the linux-3.0.73 source tarball and got the
> following error:
> 
> arch/x86/mm/numa_32.c:107: error: redefinition of 'alloc_remap'
> include/linux/bootmem.h:144: note: previous definition of 'alloc_remap'
> was here make[2]: *** [arch/x86/mm/numa_32.o] Error 1 make[1]: ***
> [arch/x86/mm] Error 2
> make: *** [arch/x86] Error 2
> 
> This only affects the 32-bit build of the kernel with the RHEL-6
> configuration.

Kernel 3.0.74 builds fine. The build error reported above was apparently 
fixed by this one:

 Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code

Akemi


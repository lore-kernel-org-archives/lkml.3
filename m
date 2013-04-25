Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3DYJrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:47:32 -0400
Received: from csmtp11.one.com ([195.47.247.117]:52078 "EHLO csmtp11.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab3DYJrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:47:31 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Apr 2013 05:47:31 EDT
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Thu, 25 Apr 2013 11:42:11 +0200
To: Matthew Garrett <matthew.garrett@nebula.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc8
Message-ID: <20130425094211.GA426@polaris.bitmath.org>
References: <CA+55aFyiByzrqGQ-KQcPuOQS_k=PgRRsUcQ6mRS-tCiANB+N3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyiByzrqGQ-KQcPuOQS_k=PgRRsUcQ6mRS-tCiANB+N3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, Peter, Linus,

> Yes, I was really hoping (and originally planning) to release 3.9
> final this weekend, but we had enough issues that I just didn't feel
> comfy about it. It was borderline, and none of the issues were huge,
> and maybe I could have called this just 3.9 and opened the merge
> window, but hey, another week won't hurt.

My much-bashed MBA3,1 begs to differ:

commit cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f
Author: Matthew Garrett <matthew.garrett@nebula.com>
Date:   Mon Apr 15 13:09:46 2013 -0700

    efi: Pass boot services variable info to runtime code
    
breaks EFI boot on that machine. Reverting on top of master, with
small trimmings, makes it boot again. Perhaps this patch can wait for
the next cycle?

Thanks,
Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaDEBNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 21:13:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:62962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaDEBNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 21:13:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,798,1389772800"; 
   d="scan'208";a="515211432"
Date: Fri, 4 Apr 2014 18:13:32 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
Message-ID: <20140405011332.GR32556@tassilo.jf.intel.com>
References: <52E4CF03.8030208@archlinux.org>
 <5339F739.2060207@archlinux.org>
 <20140331233450.GI32556@tassilo.jf.intel.com>
 <5339FC62.8060207@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5339FC62.8060207@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 01:38:10AM +0200, Thomas Bächler wrote:
> Am 01.04.2014 01:34, schrieb Andi Kleen:
> >> This problem persists in v3.14, i.e. I still have to revert
> >> 83460ec8dcac14142e7860a01fa59c267ac4657c in order to get a working
> >> kernel on i686. I would really appreciate if someone would actually read
> >> my original mail from about 3 months ago and write an answer.
> > 
> > Can you resend it please?
> 
> It's available here: https://lkml.org/lkml/2014/1/26/22
> 
> For convenience, here is a copy-and-paste of the full text:

I did some experiments know and I can't find any 32bit modules 
that do not load with 32bit MODVERSIONS on or off with 
a current tree.

Do you have a specific config?
Specific compiler version?

Thanks,

-Andi

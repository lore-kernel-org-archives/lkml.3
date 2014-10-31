Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbaJaRoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:44:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:61255 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbaJaRoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="624279034"
Date: Fri, 31 Oct 2014 10:42:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [PATCH] x86, boot: add hex output for debugging
Message-ID: <20141031174251.GM3274@tassilo.jf.intel.com>
References: <20141031162037.GA26233@www.outflux.net>
 <5453C49A.2000500@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5453C49A.2000500@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +void __puthex(unsigned long value)
> > +{
> > +	char alpha[2] = "0";
> > +	int bits;
> > +	unsigned char byte;
> 
> what is 'byte' for?  (unused)

Well the whole function is unused. We don't normally add unused functions
to the code because they bitrot too easily.

If you need it please just patch it in yourself.

-Andi

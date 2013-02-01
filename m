Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161229Ab3BAKtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:49:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60980 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161201Ab3BAKtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:49:16 -0500
Date: Fri, 1 Feb 2013 10:46:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v4] arm: use built-in byte swap function
Message-ID: <20130201104626.GH23505@n2100.arm.linux.org.uk>
References: <1359478014.3529.157.camel@shinybook.infradead.org> <20130129174249.GB25415@pd.tnic> <1359482147.3529.161.camel@shinybook.infradead.org> <20130129181046.GC25415@pd.tnic> <1359541333.3529.186.camel@shinybook.infradead.org> <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com> <20130131092801.GV23505@n2100.arm.linux.org.uk> <20130131145947.f62474a0600848df86548b96@freescale.com> <1359670248.27468.13.camel@shinybook.infradead.org> <20130131183747.d56289dbd89b165cf12a9d28@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131183747.d56289dbd89b165cf12a9d28@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 06:37:47PM -0600, Kim Phillips wrote:
> +#if GCC_VERSION >= 40600
> +#define __HAVE_BUILTIN_BSWAP32__
> +#define __HAVE_BUILTIN_BSWAP64__

You really aren't listening to anything that's been said to you.

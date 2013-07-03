Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab3GCHhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:37:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:29403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab3GCHhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:37:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,986,1363158000"; 
   d="scan'208";a="359791703"
Date: Wed, 3 Jul 2013 15:36:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [FMC] BUG: scheduling while atomic: swapper/1/0x10000002
Message-ID: <20130703073658.GA27303@localhost>
References: <20130703071540.GC25674@localhost>
 <20130703073249.GA27110@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703073249.GA27110@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

On Wed, Jul 03, 2013 at 09:32:49AM +0200, Alessandro Rubini wrote:
> Hello.
> 
> > I got the below dmesg and the first bad commit is
> > 
> > commit 4debfe409b6e550032bfef9733e9f6f7c5613617
> > Author: Alessandro Rubini <rubini@gnudd.com>
> > Date:   Tue Jun 18 23:48:07 2013 +0200
> > 
> >     FMC: add a char-device mezzanine driver
> 
> thank you for your report. I already got a problem report with
> built-in FMC subsystem, but I couldn't reproduce it.  Actually, I use
> drivers/fmc daily (I'm currently finalizing an ADC driver), but I run
> the whole subsystem as module; it never happens in that case.
> 
> Thank you for bisecting, I'll take a deeper look as soon as possible
> (hopefully today).  Meanwhile, please disable FMC or build as modules.

No problem for me. I actually run the tests in KVM which does not have
real FMC hardware at all.

Thanks,
Fengguang

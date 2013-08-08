Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3HHEjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 00:39:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:11606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab3HHEjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 00:39:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,836,1367996400"; 
   d="scan'208";a="279231317"
Date: Wed, 7 Aug 2013 21:39:06 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use gcc alias instead of assembler aliases for syscalls
Message-ID: <20130808043906.GB23412@tassilo.jf.intel.com>
References: <1375740575-7640-1-git-send-email-andi@firstfloor.org>
 <20130807165421.0b60ee9acbd1571426188448@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807165421.0b60ee9acbd1571426188448@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 04:54:21PM -0700, Andrew Morton wrote:
> On Mon,  5 Aug 2013 15:09:35 -0700 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Use standard gcc __attribute__((alias(foo))) to define
> > the syscall aliases instead of custom assembler macros.
> > 
> > This is far cleaner, and also fixes my LTO kernel build.
> > 
> 
> This makes my x86_64 allmodconfig build emit screenfuls of

Ok I can reproduce with MODVERSIONS. Very mysterious, as I 
didn't change EXPORT_SYMBOL. Will look into it.

Thanks.

-Andi

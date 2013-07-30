Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3G3OyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:54:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3G3OyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:54:09 -0400
Date: Tue, 30 Jul 2013 16:54:05 +0200
From: Borislav Petkov <bp@suse.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH resend] drop_caches: add some documentation and info
 message
Message-ID: <20130730145405.GA23365@pd.tnic>
References: <1374842669-22844-1-git-send-email-mhocko@suse.cz>
 <20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org>
 <20130730074531.GA10584@dhcp22.suse.cz>
 <20130730012544.2f33ebf6.akpm@linux-foundation.org>
 <20130730125525.GB15847@dhcp22.suse.cz>
 <51F7D1F0.20309@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51F7D1F0.20309@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 07:47:12AM -0700, Dave Hansen wrote:
> On 07/30/2013 05:55 AM, Michal Hocko wrote:
> >> > If we add another flag in the future it can use bit 3?
> > What if we get crazy and need more of them?
> 
> I really hate using bits for these kinds of interfaces.  I'm forgetful
> and never remember which bit is which, and they're possible to run out of.
> 
> I'm not saying do it now, but we can switch over to:
> 
> 	echo 'slab|pagecache' > drop_caches
> or
> 	echo 'quiet|slab' > drop_caches
> 
> any time we want and still have compatibility with the existing bitwise
> interface.

Hohum, definitely a nice idea at a first glance. And when you cat
drop_caches, it could show you what all those commands mean and how you
can issue them, i.e. allowed syntax etc.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

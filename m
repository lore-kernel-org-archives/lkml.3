Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3BQJyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 04:54:51 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:37151 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3BQJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 04:54:50 -0500
Date: Sun, 17 Feb 2013 10:54:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Glauber Costa <glommer@parallels.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] ia64: rename cache_show to topology_cache_show
Message-ID: <20130217095445.GA24857@dhcp22.suse.cz>
References: <511e236a.o0ibbB2U8xMoURgd%fengguang.wu@intel.com>
 <1360931904-5720-1-git-send-email-mhocko@suse.cz>
 <20130215144629.be18bae9.akpm@linux-foundation.org>
 <20130216121853.GA12196@dhcp22.suse.cz>
 <20130217013649.GB6775@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130217013649.GB6775@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 17-02-13 09:36:49, Wu Fengguang wrote:
> On Sat, Feb 16, 2013 at 01:18:53PM +0100, Michal Hocko wrote:
> > On Fri 15-02-13 14:46:29, Andrew Morton wrote:
> > > On Fri, 15 Feb 2013 13:38:24 +0100
> > > Michal Hocko <mhocko@suse.cz> wrote:
> > > 
> > > > Fenguang Wu has reported the following compile time issue
> > > > arch/ia64/kernel/topology.c:278:16: error: conflicting types for 'cache_show'
> > > > include/linux/slab.h:224:5: note: previous declaration of 'cache_show' was here
> > > > 
> > > > which has been introduced by 749c5415 (memcg: aggregate memcg cache
> > > > values in slabinfo). Let's rename ia64 local function to prevent from
> > > > the name conflict.
> > > 
> > > Confused.  Tony fixed this ages ago?
> > 
> > Yes but it was after 3.7 so I didn't have it in my tree and I found out
> > only after I sent this email. Sorry about the confusion.
> 
> Michal, sorry about the confusions. Does this indicate anything
> improveable in the build test/notification?

No, the message was clear. I should have checked Linus's tree before
posting the fix.

-- 
Michal Hocko
SUSE Labs

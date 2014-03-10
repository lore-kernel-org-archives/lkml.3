Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaCJXb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 19:31:26 -0400
Received: from one.firstfloor.org ([193.170.194.197]:47009 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaCJXbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 19:31:25 -0400
Date: Tue, 11 Mar 2014 00:31:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: perf: Add support for full Intel event lists
Message-ID: <20140310233123.GN22728@two.firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394480354.23624.7.camel@deadeye.wl.decadent.org.uk>
 <20140310221420.GM22728@two.firstfloor.org>
 <1394493216.23624.17.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394493216.23624.17.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't want people shipping those.  It just causes lots 
> > of outdated events everywhere, like in oprofile.
> 
> Sure, no-one should be shipping files under /var/cache.  It would be a
> an alternate download location.

You mean root perf download downloading there? But then people would
download as root. I think I prefer them downloading as their
own user.

So I think it's better to have it per user. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

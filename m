Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3BDRmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:42:39 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:36737 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3BDRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:42:38 -0500
Date: Mon, 4 Feb 2013 09:42:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 59/62] mac80211: convert to idr_alloc()
Message-ID: <20130204174232.GO27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-60-git-send-email-tj@kernel.org>
 <1359999624.17993.21.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359999624.17993.21.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 06:40:24PM +0100, Johannes Berg wrote:
> On Sat, 2013-02-02 at 17:21 -0800, Tejun Heo wrote:
> > Convert to the much saner new idr interface.
> > 
> > Only compile tested.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Cc: linux-wireless@vger.kernel.org
> > ---
> > This patch depends on an earlier idr changes and I think it would be
> > best to route these together through -mm.  Please holler if there's
> > any objection.  Thanks.
> 
> Looks fine to me, thanks.

Will add Acked-by.  Thanks a lot!

-- 
tejun

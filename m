Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685Ab3CMMgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:36:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582Ab3CMMgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:36:11 -0400
Date: Wed, 13 Mar 2013 13:36:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2013-03-07-15-45 uploaded
Message-ID: <20130313123608.GD13954@dhcp22.suse.cz>
References: <20130307234619.D2DD531C1BF@corp2gmr1-1.hot.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307234619.D2DD531C1BF@corp2gmr1-1.hot.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu 07-03-13 15:46:19, Andrew Morton wrote:
[...]
> A git tree which contains the memory management portion of this tree is
> maintained at git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
> by Michal Hocko.  It contains the patches which are between the
> "#NEXT_PATCHES_START mm" and "#NEXT_PATCHES_END" markers, from the series
> file, http://www.ozlabs.org/~akpm/mmotm/series.

It took a bit longer (as I was on vacation and scripts haven't coped with
all the idr changes) but the tree is up-to-date again.

Sorry about the delay.
-- 
Michal Hocko
SUSE Labs

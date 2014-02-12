Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaBLChP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:37:15 -0500
Received: from one.firstfloor.org ([193.170.194.197]:57268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaBLChN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:37:13 -0500
Date: Wed, 12 Feb 2014 03:37:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mtosatti@redhat.com, mgorman@suse.de, aarcange@redhat.com,
        riel@redhat.com
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140212023711.GT11821@two.firstfloor.org>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
 <20140211211732.GS11821@two.firstfloor.org>
 <20140211163108.3136d55a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211163108.3136d55a@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The real syntax is hugepagesnid=nid,nr-pages,size. Which looks straightforward
> to me. I honestly can't think of anything better than that, but I'm open for
> suggestions.

hugepages_node=nid:nr-pages:size,... ? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

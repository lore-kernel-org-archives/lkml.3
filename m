Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3LPRUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:20:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:45501 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab3LPRUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:20:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,496,1384329600"; 
   d="scan'208";a="425473535"
Date: Mon, 16 Dec 2013 09:20:29 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pravin B Shelar <pshelar@nicira.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC][PATCH 1/7] mm: print more details for bad_page()
Message-ID: <20131216172029.GY22695@tassilo.jf.intel.com>
References: <20131213235903.8236C539@viggo.jf.intel.com>
 <20131213235904.D69C09F7@viggo.jf.intel.com>
 <00000142fc5326bf-37eaf439-1c10-448f-9cd3-8137290680ca-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142fc5326bf-37eaf439-1c10-448f-9cd3-8137290680ca-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 04:52:57PM +0000, Christoph Lameter wrote:
> On Fri, 13 Dec 2013, Dave Hansen wrote:
> 
> > This way, the messages will show specifically why the page was
> > bad, *specifically* which flags it is complaining about, if it
> > was a page flag combination which was the problem.
> 
> Yes this would have been helpful in the past for me.

Yes, for me too. </AOL>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

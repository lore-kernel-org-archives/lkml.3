Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935302Ab3DHLxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:53:50 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:50622 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934981Ab3DHLxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:53:48 -0400
Date: Mon, 8 Apr 2013 13:53:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130408115344.GA7513@gmail.com>
References: <515E92CE.2000509@canonical.com>
 <20130405142104.GB29290@pd.tnic>
 <20130406145804.GJ3423@redhat.com>
 <20130406154751.GB3612@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406154751.GB3612@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> > have been the source of the confusion. Remove the noop initialization
> > accordingly.
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> 
> Yeah, looks good to me. I've folded it into my pile of changes touching this and 
> there are no visible issues. [...]

Logistics question: is this fix coming upstream-wards via your pile of changes 
anytime soon?

Thanks,

	Ingo

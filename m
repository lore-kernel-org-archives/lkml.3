Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaGTVTH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:19:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:33049 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaGTVTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:19:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,697,1400050800"; 
   d="scan'208";a="572776518"
Date: Sun, 20 Jul 2014 14:19:01 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dirk Gouders <dirk@gouders.net>,
        mmarek@suse.cz
Subject: Re: [PATCH 1/2] kbuild: Support split debug info v3
Message-ID: <20140720211901.GQ5803@tassilo.jf.intel.com>
References: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
 <20140720190420.GA4630@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720190420.GA4630@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why are as only called with -Wa,-gdwarf-2 in the non-split case?
> Is this a bug or intentional?
> If it is intentional then it is not explained.

Probably was a merging mistake. Will fix.

> > +	help
> > +	  Generate debug info into separate .dwo files. This can be
> > +	  faster for building than including the debug information directly
> Here the "faster" part is promoted.
> But in your cover letter you actually highlight the "smaller" case
> as more significant.
> Maybe include info on both positive items.

I currently don't see it significantly faster in my setup, will
mention size. It may be in others though. Feel free to test.

-Andi

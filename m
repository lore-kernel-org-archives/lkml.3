Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaIXOf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:35:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:28022 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbaIXOf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,589,1406617200"; 
   d="scan'208";a="596204162"
Date: Wed, 24 Sep 2014 07:35:55 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: string.c:  Added a funktion function strzcpy
Message-ID: <20140924143555.GJ28253@tassilo.jf.intel.com>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140924011753.GG28253@tassilo.jf.intel.com>
 <20140924075206.GC5865@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924075206.GC5865@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:52:06AM +0300, Dan Carpenter wrote:
> On Tue, Sep 23, 2014 at 06:17:53PM -0700, Andi Kleen wrote:
> > On Wed, Sep 24, 2014 at 12:13:36AM +0200, Rickard Strandqvist wrote:
> > > Added a function strzcpy which works the same as strncpy,
> > > but guaranteed to produce the trailing null character.
> > 
> > Do we really need the bizarre strncpy padding semantics for anything?
> > Why not just use strlcpy?
> 
> We do need the padding in many places to prevent information leaks.

Like where?

Usually explicit memset is far cleaner/safer.

-andi
-- 
ak@linux.intel.com -- Speaking for myself only

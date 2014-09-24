Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaIXO7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:59:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:11951 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbaIXO67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:58:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,589,1406617200"; 
   d="scan'208";a="596213112"
Date: Wed, 24 Sep 2014 07:58:58 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: string.c: Added a funktion function strzcpy
Message-ID: <20140924145858.GK28253@tassilo.jf.intel.com>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140924011753.GG28253@tassilo.jf.intel.com>
 <20140924075206.GC5865@mwanda>
 <20140924143555.GJ28253@tassilo.jf.intel.com>
 <CAFo99gZUfFUB9xX0GYW=hJMNouiU-M9apZ8KtPg9MW3x7gxZcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gZUfFUB9xX0GYW=hJMNouiU-M9apZ8KtPg9MW3x7gxZcg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can show a large amount of patches that show that many people do not
> seem aware that strncpy does not guarantee a terminating null character.
> Add to that all the code I've seen like this:

Yes that's understood.

The question was: where do we rely on the padding semantics of strncpy?

-Andi

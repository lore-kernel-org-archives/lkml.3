Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaIXWzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:55:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:19116 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaIXWzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:55:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,591,1406617200"; 
   d="scan'208";a="596418884"
Date: Wed, 24 Sep 2014 15:55:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: string.c: Added a funktion function strzcpy
Message-ID: <20140924225508.GO28253@tassilo.jf.intel.com>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140924011753.GG28253@tassilo.jf.intel.com>
 <20140924075206.GC5865@mwanda>
 <20140924143555.GJ28253@tassilo.jf.intel.com>
 <20140924154142.GG5865@mwanda>
 <CAFo99gbGoyf6GEt4ST_Q_WfYe39j+ke7t7XL6QZBYvMesMNZQg@mail.gmail.com>
 <20140924142632.7fe876ce1e743753581160a9@linux-foundation.org>
 <CAFo99gY8PAxTAourZpRDBosX9qWiOq_fS1xOHPAzujOwEhfCFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gY8PAxTAourZpRDBosX9qWiOq_fS1xOHPAzujOwEhfCFw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thought that I was still fairly clear, or that I just assumed that
> everyone was more or less familiar with the problems between strncpy
> strlcpy etc.
> Did not think all that should be includerad in chang log.

I don't think you need to write a novel. 

So the basic issue is that you're not sure if you can replace
strncpy with strlcpy (due to not knowing what the padding 
requirements are), but you still want to make sure everything
is zero terminated.

That should have been in the changelog.

-Andi


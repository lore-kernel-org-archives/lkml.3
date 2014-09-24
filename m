Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaIXB3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:29:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:61314 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbaIXB3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:29:48 -0400
X-Greylist: delayed 698 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 21:29:48 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,584,1406617200"; 
   d="scan'208";a="607505794"
Date: Tue, 23 Sep 2014 18:17:53 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: string.c:  Added a funktion function strzcpy
Message-ID: <20140924011753.GG28253@tassilo.jf.intel.com>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:13:36AM +0200, Rickard Strandqvist wrote:
> Added a function strzcpy which works the same as strncpy,
> but guaranteed to produce the trailing null character.

Do we really need the bizarre strncpy padding semantics for anything? 
Why not just use strlcpy?

-Andi

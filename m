Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaFXRp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:45:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:25679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaFXRpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:45:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,539,1400050800"; 
   d="scan'208";a="533380094"
Date: Tue, 24 Jun 2014 10:42:28 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: cleanup mcelog paragraph
Message-ID: <20140624174228.GH8178@tassilo.jf.intel.com>
References: <1403611956.1960.17.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403611956.1960.17.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 02:12:36PM +0200, Paul Bolle wrote:
> The paragraph on mcelog currently describes kernel v2.6.31. In that
> kernel the mce code (for i386, that is) was in transition. Ever since
> v2.6.32 the situation is much simpler (eg, mcelog is now needed to
> process events on almost all x86 machines, i386 and x86-64). Since this
> "document is designed to provide a list of the minimum levels of
> software necessary to run the 3.0 kernels" let's just describe that
> situation.

Looks good.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

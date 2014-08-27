Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbaH0JFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:05:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16508 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaH0JFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:05:49 -0400
Date: Wed, 27 Aug 2014 12:05:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] lib: string: Make all calls to strnicmp into
 calls to strncasecmp
Message-ID: <20140827090537.GL5100@mwanda>
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
 <1409124962-11527-3-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409124962-11527-3-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 09:36:02AM +0200, Rasmus Villemoes wrote:
> The previous patch made strnicmp into a wrapper for strncasecmp. This
> patch makes all in-tree users of strnicmp call strncasecmp directly,
> while still making sure that the strnicmp symbol can be used by
> out-of-tree modules. It should be considered a temporary hack until
> all in-tree callers have been converted.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Won't GCC just do the right thing without this second patch?

regards,
dan carpenter

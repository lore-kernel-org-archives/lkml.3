Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbaH0KRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:17:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24239 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623AbaH0KRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:17:36 -0400
Date: Wed, 27 Aug 2014 13:17:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] lib: string: Make all calls to strnicmp into
 calls to strncasecmp
Message-ID: <20140827101727.GH5046@mwanda>
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
 <1409124962-11527-3-git-send-email-linux@rasmusvillemoes.dk>
 <20140827090537.GL5100@mwanda>
 <87sikie1n7.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sikie1n7.fsf@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:13:16AM +0200, Rasmus Villemoes wrote:
> Anyway, I was also planning on sending tree-wide patches doing
> s/strnicmp/strncasecmp/, and then removing the hack from string.h, but I
> first wanted to get feedback on the first patch and maybe some guidance
> on how to properly deal with the module issue (e.g., does the kernel
> need to export a strnicmp symbol forever?).

Once we remove the in kernel users then we can remove the function.
Don't worry about out of tree modules.

regards,
dan carpenter


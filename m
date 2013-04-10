Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab3DJMmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:42:23 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:33128 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935318Ab3DJMmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:42:22 -0400
Date: Wed, 10 Apr 2013 13:41:39 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
Message-ID: <20130410124139.GT7511@dm>
References: <1365563834.27174.12.camel@joe-AO722>
 <20130410093346.GO7511@dm>
 <1365593271.27174.35.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365593271.27174.35.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:27:51AM -0700, Joe Perches wrote:

> like
> 	0 == foo
> instead of
> 	foo == 0
> 
> there were _way_ too many false positives of
> the $Expression sort that I didn't add that test.

Makes sense then as it is.

Thanks.

-apw

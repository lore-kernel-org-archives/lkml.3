Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaJQCta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 22:49:30 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64909 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaJQCt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 22:49:29 -0400
Date: Fri, 17 Oct 2014 18:46:01 +0800
From: Fengwei Yin <yfw.kernel@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        fengguang.wu@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] smaps should deal with huge zero page exactly same as
 normal zero page
Message-ID: <20141017104508.GA24192@gmail.com>
References: <CADUXgx7QTWBMxesxgCet5rjpGu-V-xK_-5f2rX9R+v-ggi902A@mail.gmail.com>
 <5436B98E.1070407@intel.com>
 <20141010132027.GB25038@gmail.com>
 <5437EEA3.50705@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5437EEA3.50705@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 07:35:15AM -0700, Dave Hansen wrote:
> On 10/10/2014 06:21 AM, Fengwei Yin wrote:
> > @@ -787,6 +788,9 @@ check_pfn:
> >  		return NULL;
> >  	}
> >  
> > +	if (is_huge_zero_pfn(pfn))
> > +		return NULL;
> > +
> 
> That looks a lot better.  One thing, why not put the is_huge_zero_pfn()
> check next to the is_zero_pfn() check?
Hi,
If no further comment, what's the next step to push this patch merged?
:). Thanks a lot.

Regards
Yin, Fengwei


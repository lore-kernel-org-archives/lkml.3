Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971Ab3DDQ1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:27:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:13679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762820Ab3DDQ1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:27:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,410,1363158000"; 
   d="scan'208";a="289422293"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <515D9041.8080000@oracle.com>
References: <51559150.3040407@oracle.com>
 <515D882E.6040001@oracle.com>
 <20130404143048.02672E0085@blue.fi.intel.com>
 <515D9041.8080000@oracle.com>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
Content-Transfer-Encoding: 7bit
Message-Id: <20130404162851.39ECBE0085@blue.fi.intel.com>
Date: Thu,  4 Apr 2013 19:28:51 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin wrote:
> On 04/04/2013 10:30 AM, Kirill A. Shutemov wrote:
> > Sasha Levin wrote:
> >> Ping? I'm seeing a whole bunch of these with current -next.
> > 
> > Do you have a way to reproduce?
> 
> Not really, trinity just manages to make it happen quite often.
> 
> I can add something in the code to spew more debug info when it
> happens though, I just couldn't come up with anything that might
> be useful.

I will try to reproduce on my own.

I'm new with trinity. Any hint on run parameters?
Is 'trinity -g vm -C 8' in lkvm good enough?

-- 
 Kirill A. Shutemov

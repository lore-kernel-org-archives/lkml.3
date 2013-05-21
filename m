Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3EUX50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:57:26 -0400
Received: from www.sr71.net ([198.145.64.142]:46539 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab3EUX5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:57:25 -0400
Message-ID: <519C09E3.30203@sr71.net>
Date: Tue, 21 May 2013 16:57:23 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 32/39] mm: cleanup __do_fault() implementation
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-33-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1368321816-17719-33-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Let's cleanup __do_fault() to prepare it for transparent huge pages
> support injection.
> 
> Cleanups:
>  - int -> bool where appropriate;
>  - unindent some code by reverting 'if' condition;
>  - extract !pte_same() path to get it clear;
>  - separate pte update from mm stats update;
>  - some comments reformated;

I've scanned through the rest of these patches.  They look OK, and I
don't have _too_ much to say.  They definitely need some closer review,
but I think you should concentrate your attention on the stuff _before_
this point in the series.


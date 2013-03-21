Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3CUPZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:25:16 -0400
Received: from www.sr71.net ([198.145.64.142]:49857 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab3CUPZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:25:11 -0400
Message-ID: <514B269F.8090701@sr71.net>
Date: Thu, 21 Mar 2013 08:26:23 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Hillf Danton <dhillf@gmail.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 03/30] mm: drop actor argument of do_generic_file_read()
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-4-git-send-email-kirill.shutemov@linux.intel.com> <CAJd=RBAKGiCb_+yoFog6xao5bF8vqFwE9MGZ9EVbf1fe-dXnDQ@mail.gmail.com> <20130315132246.F0542E0085@blue.fi.intel.com>
In-Reply-To: <20130315132246.F0542E0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:22 AM, Kirill A. Shutemov wrote:
> Hillf Danton wrote:
>> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
>> <kirill.shutemov@linux.intel.com> wrote:
>>>
>>> There's only one caller of do_generic_file_read() and the only actor is
>>> file_read_actor(). No reason to have a callback parameter.
>>>
>> This cleanup is not urgent if it nukes no barrier for THP cache.
> 
> Yes, it's not urgent. On other hand it can be applied upstream right now ;)

If someone might pick this up and merge it right away, it's probably
best to put it very first in the series and call it out as such to the
person you expect to pick it up, or even send it up to them separately.

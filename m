Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3CONfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:35:52 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:38351 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3CONft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130315132911.63716E0085@blue.fi.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1363283435-7666-20-git-send-email-kirill.shutemov@linux.intel.com>
	<CAJd=RBD2jWsMOjwXenbHu_Y3-jRm+=XR+h44Tw4KRKEb79ptqg@mail.gmail.com>
	<20130315132911.63716E0085@blue.fi.intel.com>
Date: Fri, 15 Mar 2013 21:35:49 +0800
Message-ID: <CAJd=RBAEOF7qx1=6vUAA7wYKq6i8efz=Mr9BvUHGxgEE4c6rvg@mail.gmail.com>
Subject: Re: [PATCHv2, RFC 19/30] thp, mm: split huge page on mmap file page
From: Hillf Danton <dhillf@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 9:29 PM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Hillf Danton wrote:
>> On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
>> <kirill.shutemov@linux.intel.com> wrote:
>> >
>> > We are not ready to mmap file-backed tranparent huge pages.
>> >
>> It is not on todo list either.
>
> Actually, following patches implement mmap for file-backed thp and this
> split_huge_page() will catch only fallback cases.
>
I wonder if the effort we pay for THP cache is nuked by mmap.

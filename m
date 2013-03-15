Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3COG7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:59:03 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43633 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3COG7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <1363283435-7666-20-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1363283435-7666-20-git-send-email-kirill.shutemov@linux.intel.com>
Date: Fri, 15 Mar 2013 14:58:58 +0800
Message-ID: <CAJd=RBD2jWsMOjwXenbHu_Y3-jRm+=XR+h44Tw4KRKEb79ptqg@mail.gmail.com>
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

On Fri, Mar 15, 2013 at 1:50 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> We are not ready to mmap file-backed tranparent huge pages.
>
It is not on todo list either.

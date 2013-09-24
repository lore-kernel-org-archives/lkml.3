Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3IXXhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 19:37:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3IXXhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 19:37:42 -0400
Date: Tue, 24 Sep 2013 16:37:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1,
 everything but mmap()
Message-Id: <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
In-Reply-To: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013 15:05:28 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> It brings thp support for ramfs, but without mmap() -- it will be posted
> separately.

We were never going to do this :(

Has anyone reviewed these patches much yet?

> Please review and consider applying.

It appears rather too immature at this stage.

> Intro
> -----
> 
> The goal of the project is preparing kernel infrastructure to handle huge
> pages in page cache.
> 
> To proof that the proposed changes are functional we enable the feature
> for the most simple file system -- ramfs. ramfs is not that useful by
> itself, but it's good pilot project.

At the very least we should get this done for a real filesystem to see
how intrusive the changes are and to evaluate the performance changes.


Sigh.  A pox on whoever thought up huge pages.  Words cannot express
how much of a godawful mess they have made of Linux MM.  And it hasn't
ended yet :( My take is that we'd need to see some very attractive and
convincing real-world performance numbers before even thinking of
taking this on.




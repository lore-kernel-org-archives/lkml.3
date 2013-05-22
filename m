Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3EVLTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:19:15 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43717 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3EVLTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <1368321816-17719-9-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1368321816-17719-9-git-send-email-kirill.shutemov@linux.intel.com>
Date: Wed, 22 May 2013 19:19:11 +0800
Message-ID: <CAJd=RBCOGY6Si+uORbqtFxLCD4fs3tyGvtS_y5hQTP6Y_6CeAg@mail.gmail.com>
Subject: Re: [PATCHv4 08/39] thp: compile-time and sysfs knob for thp pagecache
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
        Dave Hansen <dave@sr71.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 9:23 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> For now, TRANSPARENT_HUGEPAGE_PAGECACHE is only implemented for X86_64.
>
How about THPC, TRANSPARENT_HUGEPAGE_CACHE?

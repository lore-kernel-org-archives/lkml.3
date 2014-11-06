Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaKFPqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:46:19 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:62891 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaKFPqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:46:15 -0500
MIME-Version: 1.0
In-Reply-To: <20141106075641.GB15966@infradead.org>
References: <cover.1415220890.git.milosz@adfin.com>
	<20141106075641.GB15966@infradead.org>
Date: Thu, 6 Nov 2014 10:46:13 -0500
Message-ID: <CANP1eJEjpQ6Kbk-GENocte2Dqeo7C-E54c-MWEm-BnQ=pD+xuw@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] vfs: Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 2:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
> This series looks good, do you also have a man page sniplet to document
> the new syscalls?
>

I just send out the two patches for the man pages, ran out of time
yesterday to update it for RWF_ODSYNC.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

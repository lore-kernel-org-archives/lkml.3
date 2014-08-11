Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaHKRCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaHKRCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:02:41 -0400
Date: Mon, 11 Aug 2014 19:00:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] fs/proc/task_nommu.c: copy-and-paste the changes from
	task_mmu.c
Message-ID: <20140811170008.GA24629@redhat.com>
References: <20140805194627.GA30693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, could you review? The changes are simple, but I am not familiar
with NOMMU and I can't test this.

Depends on

	[PATCH v2 3/7] proc: introduce proc_mem_open()
	http://marc.info/?l=linux-kernel&m=140726831328943

	[PATCH v2 4/7] fs/proc/task_mmu.c: shift mm_access() from m_start() to proc_maps_open()
	http://marc.info/?l=linux-kernel&m=140726828328929
	(only because it adds proc_maps_private->mm)

I'll also send you mbox with the previous series just in case.

Oleg.

 fs/proc/task_nommu.c |   65 ++++++++++++++++++++++++++++++--------------------
 1 files changed, 39 insertions(+), 26 deletions(-)


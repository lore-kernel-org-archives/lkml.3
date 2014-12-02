Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039AbaLBMA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:00:26 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:53692 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbaLBMAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:00:25 -0500
Date: Tue, 2 Dec 2014 14:00:15 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: memory: remove ->vm_file check on shared
 writable vmas
Message-ID: <20141202120015.GC22683@node.dhcp.inet.fi>
References: <1417474682-29326-1-git-send-email-hannes@cmpxchg.org>
 <1417474682-29326-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417474682-29326-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 05:58:01PM -0500, Johannes Weiner wrote:
> The only way a VMA can have shared and writable semantics is with a
> backing file.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov

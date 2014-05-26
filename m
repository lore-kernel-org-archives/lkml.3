Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaEZVGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:06:18 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:6817 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaEZVGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:06:17 -0400
Message-ID: <1401138312.12982.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm/process_vm_access: move into ipc/
From: Davidlohr Bueso <davidlohr@hp.com>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <alpine.LSU.2.11.1405261210140.3411@eggly.anvils>
References: <20140524135925.32597.45754.stgit@zurg>
	 <alpine.LSU.2.11.1405261210140.3411@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 May 2014 14:05:12 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 12:16 -0700, Hugh Dickins wrote:
> On Sat, 24 May 2014, Konstantin Khlebnikov wrote:
> 
> > "CROSS_MEMORY_ATTACH" and mm/process_vm_access.c seems misnamed and misplaced.
> > Actually it's a kind of IPC and it has no more relation to MM than sys_read().
> > This patch moves code into ipc/ and config option into init/Kconfig.
> > 
> > Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> 
> I disagree, and SysV's ipc/ isn't where I would expect to find it.
> How about we just leave it where it is in mm?

Agreed, the ipc directory is only for sysv and posix IPC, mm is much
more suitable.


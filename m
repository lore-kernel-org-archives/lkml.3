Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaBTTsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:48:54 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59336 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaBTTsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:48:53 -0500
Date: Thu, 20 Feb 2014 14:48:48 -0500
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] kill the racy EXIT_ZOMBIE->EXIT_DEAD->EXIT_ZOMBIE
 transition
Message-ID: <20140220194848.GA6573@mtj.dyndns.org>
References: <20140220173838.GA21825@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220173838.GA21825@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 06:38:38PM +0100, Oleg Nesterov wrote:
> Tejun, unless I missed something WSTOPPED logic is broken if a process
> has a zombie/ptraced leader, "A zombie ptracee is only visible to its
> ptracer" is wrong in this case. Plus perhaps some cleanups make sense.

Heh, I already forgot most details about ptrace. :) Is it something
urgent?  If so, I'll try to get back to it right away; otherwise, I'll
probably be able to get around to it in several weeks.

Thanks.

-- 
tejun

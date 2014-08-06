Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaHFSsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:48:09 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:48434 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbaHFSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:48:07 -0400
Date: Wed, 6 Aug 2014 22:48:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] /proc/PID/*maps* fixes/cleanups
Message-ID: <20140806184803.GE20553@moon>
References: <20140805194627.GA30693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:46:28PM +0200, Oleg Nesterov wrote:
> Changes:
> 
> 	1-4: Update the changelogs, join "introduce the stable
> 	     proc_maps_private->mm" and "change m_start() to rely on
> 	     priv->mm" into a single "shift "priv->task = NULL" from
> 	     m_start() to m_stop()".
> 
> 	     Resulting code is the same. Kirill and Cyrill, you seem
> 	     to agree with these changes, I'll appreciate your acks.
> 
> 	5-7: New. Seems to work, please review.
> 
> Todo:
> 
> 	- Cleanup the tail_vma horror in m_start
> 
> 	- Update task_nommu.c in the same way
> 
> 	- Fix lock_trace() users
> 
> Oleg.

(Sorry for delay) Thanks a lot, Oleg!
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
to whole series

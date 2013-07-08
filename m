Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3GHOXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:23:04 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:9169 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3GHOXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:23:02 -0400
Message-ID: <51DACB2F.10309@hp.com>
Date: Mon, 08 Jul 2013 10:22:39 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v5 00/12] Lockless update of reference count protected
 by spinlock
References: <1373035656-40600-1-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307052223250.32106@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307052223250.32106@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 04:33 PM, Thomas Gleixner wrote:
> On Fri, 5 Jul 2013, Waiman Long wrote:
>> patch 1:	Introduce the new lockref data structure
>> patch 2:	Enable x86 architecture to use the feature
>> patch 3:	Rename all d_count references to d_refcount
> And after that the mail threading does not work anymore, because you
> managed to lose the
>
> In-Reply-To:<1373035656-40600-1-git-send-email-Waiman.Long@hp.com>
> References:<1373035656-40600-1-git-send-email-Waiman.Long@hp.com>
>
> tags in patches 4-12

Thank for pointing this out. I will change the way I send the patch to 
fix this issue in the next revision of the patch.

Regards,
Longman

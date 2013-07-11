Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3GKNtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:49:06 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46312 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab3GKNtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:49:04 -0400
Message-ID: <51DEB7BE.3030609@hp.com>
Date: Thu, 11 Jul 2013 09:48:46 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v6 03/14] dcache: Add a new helper function d_count()
 to return refcount
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com> <1373332204-10379-4-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1373332204-10379-4-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 09:09 PM, Waiman Long wrote:
> This patch adds a new helper function d_count() in dcache.h for
> returning the current reference count of the dentry object. It
> should be used by all the files outside of the core dcache.c and
> namei.c files.

I want to know people's thought of spinning out patches 3-11 of this 
patch series as the making the d_count() helper the standard way of 
accessing the reference count in dentry outside of dcache.c and namei.c 
should be non-controversial. By merging it first, this will make 
revising this patch series easier and involving less people.

Regards,
Longman

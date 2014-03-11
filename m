Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaCKNzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:55:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:55460 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaCKNzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:55:13 -0400
Date: Wed, 12 Mar 2014 00:55:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: rgb@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        laijs@cn.fujitsu.com, akpm@linux-foundation.org, joe@perches.com,
        keescook@chromium.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
        tglx@linutronix.de, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
In-Reply-To: <201403112116.HIJ21362.OFVQJFtHOSOFLM@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.02.1403120052040.23883@tundra.namei.org>
References: <201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp> <20140307155415.GB16640@madcap2.tricolour.ca> <201403082143.BIH86903.QtVMHJFFOOSFOL@I-love.SAKURA.ne.jp> <20140310202155.GR16640@madcap2.tricolour.ca> <201403112102.HCC48418.LSOQFJOFOtFVHM@I-love.SAKURA.ne.jp>
 <201403112116.HIJ21362.OFVQJFtHOSOFLM@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014, Tetsuo Handa wrote:

> And the same phrase goes to James Morris...
> 
> If you are sure that it is safe to use get_task_comm() from
> dump_common_audit_data() and you prefer locked version, please pick up below
> patch via your git tree.
> 
> If you are unsure or prefer lockless version, I'll make a lockless version
> using do_get_task_comm() proposed in this thread.

If you can't understand whether your patch is correct or not, don't ask me 
to apply it to my tree.

If you're unsure, get it reviewed first.



- James
-- 
James Morris
<jmorris@namei.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaCCRUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:20:55 -0500
Received: from one.firstfloor.org ([193.170.194.197]:53268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaCCRUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:20:53 -0500
Date: Mon, 3 Mar 2014 18:20:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH -tip v7 24/26] kprobes: Enlarge hash table to 4096
 entries
Message-ID: <20140303172050.GZ22728@two.firstfloor.org>
References: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140227073414.20992.16882.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <87y50wut4j.fsf@tassilo.jf.intel.com>
 <530FBA99.3050504@hitachi.com>
 <53144C01.60106@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53144C01.60106@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, we can see the hash table larger than 2^9 (512 entries,
> which consumes 4KB) has no performance improvement.
> Would you think 4kB is still big for kprobes? :)

4KB should be fine. Thanks for evaluating.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaIVLbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:31:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:53827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVLbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:31:36 -0400
Date: Mon, 22 Sep 2014 13:31:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
        Francesco Fusco <ffusco@redhat.com>, Greg Thelen <gthelen@google.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        George Spelvin <linux@horizon.com>, Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] lib: remove prio_heap
Message-ID: <20140922113133.GB2832@worktop.localdomain>
References: <1411373687-11873-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411373687-11873-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 04:14:35PM +0800, Lai Jiangshan wrote:
> The prio_heap was unused since 889ed9ceaa97 ("cgroup: remove css_scan_tasks()"),
> it should be compiled-out for shrinking the binary kernel size which can be
> done via introducing CONFIG_PRIO_HEAD or via removing the code.
> 
> But we can simply recover the code from the git quickly when needed,
> so it would be better to remove it IMO.
> 

Sounds like a wonderful cleanup, that code always gave me head-aches :-)

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

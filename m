Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaIWOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:25:27 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56768 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbaIWOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:25:20 -0400
Date: Tue, 23 Sep 2014 10:25:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>, Francesco Fusco <ffusco@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        George Spelvin <linux@horizon.com>, Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] lib: remove prio_heap
Message-ID: <20140923142515.GB19208@htj.dyndns.org>
References: <1411373687-11873-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411373687-11873-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

FWIW, Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

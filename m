Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3FONOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:14:40 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49160 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3FONOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:14:38 -0400
Date: Sat, 15 Jun 2013 15:14:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/3] hw_breakpoint: Simplify the "weight" usage in
 toggle_bp_slot() paths
Message-ID: <20130615131432.GC1965@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601194526.GA27149@redhat.com>
 <20130601194606.GC27149@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601194606.GC27149@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 09:46:06PM +0200, Oleg Nesterov wrote:
> Change toggle_bp_slot() to make "weight" negative if !enable. This
> way we can always use "+ weight" without additional "if (enable)"
> check and toggle_bp_task_slot() no longer needs this arg.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

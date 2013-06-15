Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3FON3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:29:33 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33944 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3FON3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:29:32 -0400
Date: Sat, 15 Jun 2013 15:29:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 3/3] hw_breakpoint: Introduce cpumask_of_bp()
Message-ID: <20130615132927.GD1965@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601194526.GA27149@redhat.com>
 <20130601194626.GD27149@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601194626.GD27149@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 09:46:26PM +0200, Oleg Nesterov wrote:
> Add the trivial helper which simply returns cpumask_of() or
> cpu_possible_mask depending on bp->cpu.
> 
> Change fetch_bp_busy_slots() and toggle_bp_slot() to always do
> for_each_cpu(cpumask_of_bp) to simplify the code and avoid the
> code duplication.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

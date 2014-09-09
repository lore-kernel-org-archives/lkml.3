Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaIIAVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:21:38 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:32903 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaIIAVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:21:37 -0400
Date: Mon, 8 Sep 2014 17:21:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_t
 -fix
In-Reply-To: <20140908220654.GO17501@suse.de>
Message-ID: <alpine.DEB.2.02.1409081720490.32250@chino.kir.corp.google.com>
References: <20140908220654.GO17501@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Mel Gorman wrote:

> A commit in linux-next was causing boot to fail and bisection identified
> the patch "percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_".
> The commit ID is worthless as it's a linux-next commit. One of the changes
> in that patch looks very suspicious. Reverting the full patch fixes boot
> as does this fixlet.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

I assume that since this is ipi_mask_ptr that the boot hangs instead of 
doing anything else.

Acked-by: David Rientjes <rientjes@google.com>

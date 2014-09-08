Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbaIHXqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:46:52 -0400
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:42438 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbaIHXqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:46:51 -0400
Date: Mon, 8 Sep 2014 18:46:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_t
 -fix
In-Reply-To: <20140908220654.GO17501@suse.de>
Message-ID: <alpine.DEB.2.11.1409081846340.869@gentwo.org>
References: <20140908220654.GO17501@suse.de>
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

I already acked a patch like this today.

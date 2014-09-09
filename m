Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaIIAf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:35:27 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:39923 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaIIAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:35:26 -0400
Date: Tue, 9 Sep 2014 09:35:21 +0900
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu: Resolve ambiguities in
 __get_cpu_var/cpumask_var_t -fix
Message-ID: <20140909003450.GA11623@mtj.dyndns.org>
References: <20140908220654.GO17501@suse.de>
 <alpine.DEB.2.11.1409081846340.869@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409081846340.869@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 06:46:47PM -0500, Christoph Lameter wrote:
> On Mon, 8 Sep 2014, Mel Gorman wrote:
> 
> > A commit in linux-next was causing boot to fail and bisection identified
> > the patch "percpu: Resolve ambiguities in __get_cpu_var/cpumask_var_".
> > The commit ID is worthless as it's a linux-next commit. One of the changes
> > in that patch looks very suspicious. Reverting the full patch fixes boot
> > as does this fixlet.
> 
> I already acked a patch like this today.

It isn't in my inbox.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbbAENXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:23:07 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:44200 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbbAENXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:23:05 -0500
Date: Mon, 5 Jan 2015 08:23:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: flex_proportions.c:  Remove some unused functions
Message-ID: <20150105132301.GA15833@htj.dyndns.org>
References: <1419086431-3474-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20150105084534.GA7056@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105084534.GA7056@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 09:45:34AM +0100, Jan Kara wrote:
> On Sat 20-12-14 15:40:31, Rickard Strandqvist wrote:
> > Removes some functions that are not used anywhere:
> > prop_fraction_single() prop_local_destroy_single() prop_local_init_single() fprop_global_destroy()
> > 
> > This was partially found by using a static code analysis program called cppcheck.
>   This is the same situation as with lib/proportions.c. The functions are
> there for API completeness. As far as I'm looking the whole 'single'
> section is unused so ifdeffing it out might make sense (and also ifdeffing
> out fprop_inc_single() from include/linux/flex_proportions.h). Removing
> fprop_global_destroy() is IMO pointless churn.

I'll prolly use some of the now unused portion of the API to implement
per-memcg dirty ratio for cgroup writeback, so let's please leave it
alone for now.

Thanks.

-- 
tejun

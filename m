Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583Ab3JPUG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:06:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36076 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab3JPUG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:06:57 -0400
Date: Wed, 16 Oct 2013 22:06:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131016200645.GD10651@twins.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-2-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381949500-501-2-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 08:51:39PM +0200, Thierry Reding wrote:
> Today's linux-next merge of the tip tree got a conflict in
> 
> 	include/linux/wait.h
> 
> caused by commits 1ab2460 (wait: add wait_event_cmd()) and fb869b6
> (sched/wait: Clean up wait.h details a bit).

Gargh, where did that come from?!

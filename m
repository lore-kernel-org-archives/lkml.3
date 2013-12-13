Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3LMVEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:04:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53650 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3LMVEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:04:51 -0500
Date: Fri, 13 Dec 2013 22:04:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <ak@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] perf properly document the new transaction sample type
Message-ID: <20131213210444.GB7959@laptop.programming.kicks-ass.net>
References: <1379688044-14173-2-git-send-email-andi@firstfloor.org>
 <tip-fdfbbd07e91f8fe387140776f3fd94605f0c89e5@git.kernel.org>
 <alpine.DEB.2.02.1312131526550.10244@pianoman.cluster.toy>
 <20131213203806.GR22695@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1312131548450.10372@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312131548450.10372@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 03:52:25PM -0500, Vince Weaver wrote:
> 
> Commit fdfbbd07e91f8fe3871 "perf: Add generic transaction flags"
> added support for PERF_SAMPLE_TRANSACTION but forgot to add documentation
> for the sample type to include/uapi/linux/perf_event.h
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

Thanks!

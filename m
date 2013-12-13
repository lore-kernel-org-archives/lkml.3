Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3LMUiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:38:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:5240 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab3LMUiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:38:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,481,1384329600"; 
   d="scan'208";a="424404699"
Date: Fri, 13 Dec 2013 12:38:06 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [tip:perf/core] perf: Add generic transaction flags
Message-ID: <20131213203806.GR22695@tassilo.jf.intel.com>
References: <1379688044-14173-2-git-send-email-andi@firstfloor.org>
 <tip-fdfbbd07e91f8fe387140776f3fd94605f0c89e5@git.kernel.org>
 <alpine.DEB.2.02.1312131526550.10244@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312131526550.10244@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I know this is a bit late, but isn't this patch missing something like
> (not a real patch):
> 
> 
>          *      { u64                   weight;   } && PERF_SAMPLE_WEIGHT
>          *      { u64                   data_src; } && PERF_SAMPLE_DATA_SRC
> +        *      { u64                   transaction; } && PERF_SAMPLE_TRANSACTION
>          * };
>          */

Yes it should have that. Thanks for catching. Please send a real patch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

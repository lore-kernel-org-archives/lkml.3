Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3KKORm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:17:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:16113 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab3KKORR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:17:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,678,1378882800"; 
   d="scan'208";a="431344660"
Date: Mon, 11 Nov 2013 06:17:15 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH 2/2] kallsyms: Revert back to 128 max symbol length
Message-ID: <20131111141715.GM1962@tassilo.jf.intel.com>
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz>
 <1384177236-8371-2-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384177236-8371-2-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:40:36PM +0100, Michal Marek wrote:
> This reverts commits
> f3462aa (Kbuild: Handle longer symbols in kallsyms.c) and
> eea0e9c (kbuild: Increase kallsyms max symbol length)
> except for the added overflow check. The reason is a regression caused
> by increasing the buffer:
> http://marc.info/?l=linux-kernel&m=138387700415675.

Can you please wait a bit until we tracked down the problem?


-Andi


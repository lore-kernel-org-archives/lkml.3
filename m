Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbaAHTvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:51:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:34391 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaAHTvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:51:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,626,1384329600"; 
   d="scan'208";a="463699311"
From: Andi Kleen <andi@firstfloor.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: increase static allocations
References: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
Date: Wed, 08 Jan 2014 11:51:51 -0800
In-Reply-To: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com> (Sasha
	Levin's message of "Wed, 8 Jan 2014 14:21:46 -0500")
Message-ID: <87lhyq45go.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> Fuzzing a recent kernel with a large configuration hits the static
> allocation limits and disables lockdep.

Doesn't that use a lot more memory?  I thought lockdep preallocates.

Doubling may be too aggressive.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

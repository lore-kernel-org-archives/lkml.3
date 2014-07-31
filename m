Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaGaVE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:04:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:28989 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaGaVEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="366430265"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, x86: Handle extended offcore mask on Haswell
References: <1406839689-23491-1-git-send-email-andi@firstfloor.org>
Date: Thu, 31 Jul 2014 14:04:25 -0700
In-Reply-To: <1406839689-23491-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Thu, 31 Jul 2014 13:48:09 -0700")
Message-ID: <87wqatp7dy.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> HSW-EP has a larger offcore mask than the client Haswell CPUs.
> It is the same mask as on Sandy/IvyBridge-EP.

Sorry I posted the wrong patch, not matching the description.
Use the followon patch instead.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

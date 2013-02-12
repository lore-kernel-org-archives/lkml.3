Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab3BLPO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:14:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41720 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3BLPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:14:28 -0500
Date: Tue, 12 Feb 2013 16:14:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/5] perf, x86: Move NMI clearing to end of PMI handler after the counter registers are reset
Message-ID: <20130212151426.GA30577@one.firstfloor.org>
References: <1360265019-23865-1-git-send-email-andi@firstfloor.org> <1360265019-23865-6-git-send-email-andi@firstfloor.org> <20130212084346.GB19475@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212084346.GB19475@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 09:43:46AM +0100, Ingo Molnar wrote:
> Was this stress-tested on all affected main CPU types, or only 
> on Haswell?

I tested it on Haswell and Ivy Bridge. I can also try
Westmere and a Saltwell(Atom), but for the majority of other family 6
systems I'll need to rely on the community.

White listing is somewhat difficult because it affects the architectural
mode too.

I don't really expect problems from this change, we should probably
have always done it like this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

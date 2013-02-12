Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475Ab3BLInx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 03:43:53 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64116 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab3BLInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 03:43:52 -0500
Date: Tue, 12 Feb 2013 09:43:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/5] perf, x86: Move NMI clearing to end of PMI handler
 after the counter registers are reset
Message-ID: <20130212084346.GB19475@gmail.com>
References: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
 <1360265019-23865-6-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360265019-23865-6-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> This avoids some problems with spurious PMIs on Haswell.
> Haswell seems to behave more like P4 in this regard. Do
> the same thing as the P4 perf handler by unmasking
> the NMI only at the end. Shouldn't make any difference
> for earlier non P4 cores.

Was this stress-tested on all affected main CPU types, or only 
on Haswell?

Thanks,

	Ingo

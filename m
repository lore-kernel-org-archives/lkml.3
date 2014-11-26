Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaKZITx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:19:53 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:52396 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaKZITw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:19:52 -0500
Message-ID: <54758D22.8040704@linux.vnet.ibm.com>
Date: Wed, 26 Nov 2014 09:19:46 +0100
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
CC: paulus@samba.org
Subject: Re: pseries/le: Fix endiannes issue in RTAS call from xmon
References: <20141126033136.977771401AC@ozlabs.org>
In-Reply-To: <20141126033136.977771401AC@ozlabs.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112608-0025-0000-0000-00000297DF08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/2014 04:31, Michael Ellerman wrote:
> OK. You say "LPAR", by which you mean "under phyp" I think. I haven't seen this
> under KVM, and it looks like KVM doesn't implement "set-indicator" so that
> would explain that.

Yes LPAR implies phyp, and KVM don't implement "set-indicator" so this
doesn't happen in that case.

> I'll take this as a bug fix and CC it to stable.

That's a good point.

Thanks,
Laurent.


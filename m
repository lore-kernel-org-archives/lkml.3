Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaGWFqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:46:07 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:56237 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaGWFqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:46:05 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm, arc: remove obsolete pagefault oom killer comment
Thread-Topic: [patch] mm, arc: remove obsolete pagefault oom killer comment
Thread-Index: AQHPphIrZLjlRQS6Z0a4T9juTDiBgA==
Date: Wed, 23 Jul 2014 05:45:59 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C4B4FAC@IN01WEMBXA.internal.synopsys.com>
References: <alpine.DEB.2.02.1407221804200.21164@chino.kir.corp.google.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2014 06:35 AM, David Rientjes wrote:
> Commit 609838cfed97 ("mm: invoke oom-killer from remaining unconverted page 
> fault handlers") converted arc to call pagefault_out_of_memory(), so remove
> the comment about future conversion.
>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Thx David,

Applied to ARC for-next.

-Vineet

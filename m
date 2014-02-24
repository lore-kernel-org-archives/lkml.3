Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaBXOUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:20:19 -0500
Received: from smtp.citrix.com ([66.165.176.89]:42670 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbaBXOUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:20:18 -0500
X-IronPort-AV: E=Sophos;i="4.97,535,1389744000"; 
   d="scan'208";a="105195234"
Message-ID: <530B551F.2060202@citrix.com>
Date: Mon, 24 Feb 2014 14:20:15 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Xen <xen-devel@lists.xenproject.org>, Ingo Molnar <mingo@elte.hu>,
        x86 <x86@kernel.org>
Subject: Re: [Xen-devel] [patch 15/26] x86: xen: Use the core irq stats function
References: <20140223212703.511977310@linutronix.de> <20140223212737.869264085@linutronix.de>
In-Reply-To: <20140223212737.869264085@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/14 21:40, Thomas Gleixner wrote:
> Let the core do the irq_desc resolution.
> 
> No functional change.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David

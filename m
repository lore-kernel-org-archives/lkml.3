Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaCDRQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:16:18 -0500
Received: from smtp.citrix.com ([66.165.176.89]:44929 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaCDRQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:16:16 -0500
X-IronPort-AV: E=Sophos;i="4.97,586,1389744000"; 
   d="scan'208";a="108027417"
Message-ID: <53160A51.5090905@citrix.com>
Date: Tue, 4 Mar 2014 17:16:01 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <konrad.wilk@oracle.com>, <peterz@infradead.org>,
        <xen-devel@lists.xenproject.org>, <tglx@linutronix.de>,
        <david.vrabel@citrix.com>
CC: tip-bot for Thomas Gleixner <tipbot@zytor.com>,
        <linux-tip-commits@vger.kernel.org>
Subject: Re: [Xen-devel] [tip:irq/core] xen: Get rid of the last irq_desc
 abuse
References: <20140223212738.579581220@linutronix.de> <tip-02893afdd310fab8f41f6afbe5233c6609ec19ed@git.kernel.org>
In-Reply-To: <tip-02893afdd310fab8f41f6afbe5233c6609ec19ed@git.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/14 16:41, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  02893afdd310fab8f41f6afbe5233c6609ec19ed
> Gitweb:     http://git.kernel.org/tip/02893afdd310fab8f41f6afbe5233c6609ec19ed
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Sun, 23 Feb 2014 21:40:20 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 4 Mar 2014 17:37:53 +0100
> 
> xen: Get rid of the last irq_desc abuse
> 
> Warn if any PIRQ cannot be bound to an event channel. Remove the check
> for irq_desc->action. This hypercall never fails in practice so we can
> emit a warning unconditionally.
> 
> Remove a check for a valid irq desc. The only caller of
> xen_destroy_irq() will only do so if the irq was previously fully
> setup, which means the descriptor has been allocated as well.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thanks.

David

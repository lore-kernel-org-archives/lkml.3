Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaCXGWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:22:38 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:55899 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaCXGWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:22:36 -0400
Date: Mon, 24 Mar 2014 07:22:29 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        s390 <linux-s390@vger.kernel.org>
Subject: Re: [patch 02/16] s390: tape: Add missing destroy_timer_on_stack()
Message-ID: <20140324062229.GC4487@osiris>
References: <20140323150557.288925975@linutronix.de>
 <20140323150752.720915842@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323150752.720915842@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032406-0542-0000-0000-0000086B1D6A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 03:09:25PM -0000, Thomas Gleixner wrote:
> Otherwise we leak a tracking object when DEBUG_OBJECTS is enabled.
> 

[...]

>  	del_timer_sync(&timeout);
> +	destroy_timer_on_stack(&timeout);

Applied, thanks.


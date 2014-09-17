Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaIQP4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:56:03 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27028 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaIQP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:56:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/AniVNRZBZ8hsPW2kKosZQbjduVg3ndhg=
X-DKIM: OpenDKIM Filter v2.0.1 titan A9F755E5149
Date: Wed, 17 Sep 2014 11:55:54 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/3] PCI/MSI/Armada-370-xp: Remove
 arch_msi_check_device()
Message-ID: <20140917155554.GE16945@titan.lakedaemon.net>
References: <cover.1410078503.git.agordeev@redhat.com>
 <9f3497a0f478f3ee7d4a16b9a4221d4377e5863d.1410078503.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f3497a0f478f3ee7d4a16b9a4221d4377e5863d.1410078503.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

On Sun, Sep 07, 2014 at 08:57:54PM +0200, Alexander Gordeev wrote:
> Moving MSI checks from arch_msi_check_device() function to
> arch_setup_msi_irqs() function makes code more compact and
> allows removing unnecessary hook arch_msi_check_device()
> from generic MSI code.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/irqchip/irq-armada-370-xp.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)

Now that ThomasP has had a chance to test, please adjust the subject
line to 'irqchip: armada-370-xp: M...' and

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.

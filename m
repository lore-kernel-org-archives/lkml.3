Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaIQQJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:09:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbaIQQJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:09:05 -0400
Date: Wed, 17 Sep 2014 17:17:55 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2 2/3] PCI/MSI/Armada-370-xp: Remove
 arch_msi_check_device()
Message-ID: <20140917161754.GG8793@agordeev.usersys.redhat.com>
References: <cover.1410078503.git.agordeev@redhat.com>
 <9f3497a0f478f3ee7d4a16b9a4221d4377e5863d.1410078503.git.agordeev@redhat.com>
 <20140917155554.GE16945@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917155554.GE16945@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:55:54AM -0400, Jason Cooper wrote:
> Now that ThomasP has had a chance to test, please adjust the subject
> line to 'irqchip: armada-370-xp: M...' and

Hi Bjorn,

Do you want me to resend the patch?

> Acked-by: Jason Cooper <jason@lakedaemon.net>
> 
> thx,
> 
> Jason.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

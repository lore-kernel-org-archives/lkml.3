Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaKFCQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:16:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50378 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKFCQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:16:05 -0500
Date: Wed, 05 Nov 2014 21:15:58 -0500 (EST)
Message-Id: <20141105.211558.969082848816106943.davem@davemloft.net>
To: joestringer@nicira.com
Cc: gerlitz.or@gmail.com, therbert@google.com, netdev@vger.kernel.org,
        sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com,
        linux.nics@intel.com, amirv@mellanox.com, shahed.shaikh@qlogic.com,
        Dept-GELinuxNICDev@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/5] Implement ndo_gso_check() for vxlan nics
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141106010501.GA18339@gmail.com>
References: <CAJ3xEMhxabp1EKbFPfvoZEFt=CQKFNcNrURGMX=7miDwmK9Y-A@mail.gmail.com>
	<20141105.163825.1433973842938441546.davem@davemloft.net>
	<20141106010501.GA18339@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 18:16:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Stringer <joestringer@nicira.com>
Date: Wed, 5 Nov 2014 17:06:46 -0800

> My impression was that the changes are more likely to be
> hardware-specific (like the i40e changes) rather than software-specific,
> like changes that might be integrated into the helper.

I think there is more commonality amongst hardware capabilities,
and this is why I want the helper to play itself out.

> That said, I can rework for one helper. The way I see it would be the
> same code as these patches, as "vxlan_gso_check(struct sk_buff *)" in
> drivers/net/vxlan.c which would be called from each driver. Is that what
> you had in mind?

Yes.

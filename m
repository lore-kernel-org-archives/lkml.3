Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422938AbaKNWN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:13:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45446 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161938AbaKNWNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:13:24 -0500
Date: Fri, 14 Nov 2014 17:13:21 -0500 (EST)
Message-Id: <20141114.171321.696698672872443302.davem@davemloft.net>
To: joestringer@nicira.com
Cc: netdev@vger.kernel.org, sathya.perla@emulex.com, shahed.shaikh@qlogic.com,
        amirv@mellanox.com, Dept-GELinuxNICDev@qlogic.com, therbert@google.com,
        gerlitz.or@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net 0/4] Implement ndo_gso_check() for vxlan nics
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
References: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Nov 2014 14:13:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Stringer <joestringer@nicira.com>
Date: Thu, 13 Nov 2014 16:38:11 -0800

> Most NICs that report NETIF_F_GSO_UDP_TUNNEL support VXLAN, and not other
> UDP-based encapsulation protocols where the format and size of the header may
> differ. This patch series implements a generic ndo_gso_check() for detecting
> VXLAN, then reuses it for these NICs.
> 
> Implementation shamelessly stolen from Tom Herbert (with minor fixups):
> http://thread.gmane.org/gmane.linux.network/332428/focus=333111
> 
> v2: Drop i40e/fm10k patches (code diverged; handling separately).
>     Refactor common code into vxlan_gso_check() helper.
>     Minor style fixes.

Series applied, thanks Joe.

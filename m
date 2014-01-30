Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaA3UeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 15:34:12 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:24856 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3UeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 15:34:10 -0500
X-IronPort-AV: E=Sophos;i="4.95,752,1384329600"; 
   d="scan'208";a="12326108"
Subject: Re: igb and bnx2: "NETDEV WATCHDOG: transmit queue timed out" when
 skb has huge linear buffer
From: Michael Chan <mchan@broadcom.com>
To: Zoltan Kiss <zoltan.kiss@schaman.hu>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        <e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
In-Reply-To: <52EAA31B.1090606@schaman.hu>
References: <52EAA31B.1090606@schaman.hu>
Content-Type: text/plain; charset="cp1252"
Date: Thu, 30 Jan 2014 12:34:08 -0800
Message-ID: <1391114048.4804.2.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-30 at 19:08 +0000, Zoltan Kiss wrote:
> I've experienced some queue timeout problems mentioned in the subject 
> with igb and bnx2 cards. 

Please provide the full tx timeout dmesg.  bnx2 dumps some diagnostic
information during tx timeout that may be useful.  Thanks.


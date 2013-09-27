Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab3I0PJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:09:03 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:52163 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3I0PJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:09:00 -0400
Date: Fri, 27 Sep 2013 12:08:54 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: linux-next: manual merge of the bluetooth tree with the wireless
 tree
Message-ID: <20130927150854.GA13211@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Johan Hedberg <johan.hedberg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>
References: <20130927132644.3aca01f917f0bf569a0a6942@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927132644.3aca01f917f0bf569a0a6942@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

2013-09-27 Stephen Rothwell <sfr@canb.auug.org.au>:

> Hi Gustavo,
> 
> Today's linux-next merge of the bluetooth tree got a conflict in
> net/bluetooth/hci_core.c between commit 5e130367d43f ("Bluetooth:
> Introduce a new HCI_RFKILLED flag") from the wireless tree and commit
> 0736cfa8e5bb ("Bluetooth: Introduce user channel flag for HCI devices")
> from the bluetooth tree.

Thanks for reporting, I knew about it about but didn't had any time to fix it
yesterday. I just merged bluetooth.git on bluetooth-next.git and fixed this.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> P.S. that closing brace is badly indented :-(

Yeah, it is now fixed on bluetooth-next at least.

	Gustavo

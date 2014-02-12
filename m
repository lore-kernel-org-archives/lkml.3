Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaBLAbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:31:48 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:49888 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaBLAbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:31:46 -0500
Date: Tue, 11 Feb 2014 17:31:43 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to
 pci_disable_msi()
Message-ID: <20140212003143.GD21057@google.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
 <20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
 <87y51qohjn.fsf@kamboji.qca.qualcomm.com>
 <20140204190935.GA1430@dhcp-26-207.brq.redhat.com>
 <8761oum0l3.fsf@kamboji.qca.qualcomm.com>
 <20140205085047.GA27820@dhcp-26-207.brq.redhat.com>
 <871tzilz1u.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tzilz1u.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:54:37AM +0200, Kalle Valo wrote:
> Alexander Gordeev <agordeev@redhat.com> writes:
> 
> > On Wed, Feb 05, 2014 at 10:21:28AM +0200, Kalle Valo wrote:
> >> Is it ok for me to take these patches to my ath.git tree or would you
> >> prefer to route them some other way?
> >
> > Yeah, Bjorn has indicated he would pull it to his tree.
> 
> Ok, I'll drop these from my pending branch then. I just think it would
> have been easier if I would take these, smaller chance of conflicts that
> way.
> 
> > I get it you are fine with 2/3 and 3/3?
> 
> Yes, with the addition of the commit log to 1/3 I'll give:
> 
> Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

I haven't put these in my branch, so you can take them.

Alexander has a whole batch of network driver updates that I think David
Miller is going to apply; would it make sense to include these in that
batch?

There's also the wil6210 patch for
drivers/net/wireless/ath/wil6210/pcie_bus.c, which seems like it maybe
could be in that batch, too.

Bjorn

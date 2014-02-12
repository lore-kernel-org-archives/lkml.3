Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaBLNgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:36:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbaBLNgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:36:43 -0500
Date: Wed, 12 Feb 2014 14:38:17 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to
 pci_disable_msi()
Message-ID: <20140212133816.GB3147@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
 <20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
 <87y51qohjn.fsf@kamboji.qca.qualcomm.com>
 <20140204190935.GA1430@dhcp-26-207.brq.redhat.com>
 <8761oum0l3.fsf@kamboji.qca.qualcomm.com>
 <20140205085047.GA27820@dhcp-26-207.brq.redhat.com>
 <871tzilz1u.fsf@kamboji.qca.qualcomm.com>
 <20140212003143.GD21057@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212003143.GD21057@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:31:43PM -0700, Bjorn Helgaas wrote:
> I haven't put these in my branch, so you can take them.
> 
> Alexander has a whole batch of network driver updates that I think David
> Miller is going to apply; would it make sense to include these in that
> batch?
> 
> There's also the wil6210 patch for
> drivers/net/wireless/ath/wil6210/pcie_bus.c, which seems like it maybe
> could be in that batch, too.

Well, as this series is small I thought it could quickly go thru your
tree. But since ipr had conflicts, there is no point routing all patches
altogether, so up to you guys. The wil6210 patch is already in your pci/msi
branch though.

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

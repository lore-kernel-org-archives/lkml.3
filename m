Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaBLVax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:30:53 -0500
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32449 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaBLVav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:30:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,7347"; a="59285292"
X-IronPort-AV: E=Sophos;i="4.95,834,1384329600"; 
   d="scan'208";a="629206736"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Alexander Gordeev <agordeev@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to pci_disable_msi()
References: <cover.1389904166.git.agordeev@redhat.com>
	<ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
	<20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
	<87y51qohjn.fsf@kamboji.qca.qualcomm.com>
	<20140204190935.GA1430@dhcp-26-207.brq.redhat.com>
	<8761oum0l3.fsf@kamboji.qca.qualcomm.com>
	<20140205085047.GA27820@dhcp-26-207.brq.redhat.com>
	<871tzilz1u.fsf@kamboji.qca.qualcomm.com>
	<20140212003143.GD21057@google.com>
	<20140212133816.GB3147@dhcp-26-207.brq.redhat.com>
	<CAErSpo6c_EPc5c8aaTeD9=eXWw4OowcKhWHG6YZgTOkZRMtZHQ@mail.gmail.com>
Date: Wed, 12 Feb 2014 23:30:44 +0200
In-Reply-To: <CAErSpo6c_EPc5c8aaTeD9=eXWw4OowcKhWHG6YZgTOkZRMtZHQ@mail.gmail.com>
	(Bjorn Helgaas's message of "Wed, 12 Feb 2014 12:28:00 -0700")
Message-ID: <87ppmsauij.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

>> Well, as this series is small I thought it could quickly go thru your
>> tree. But since ipr had conflicts, there is no point routing all patches
>> altogether, so up to you guys. The wil6210 patch is already in your pci/msi
>> branch though.
>
> It's in pci/msi, but that's not in my -next branch yet, so I can
> easily drop it.  Do drivers/net/wireless patches normally follow a
> different path than the other drivers/net patches?  The wil6210 and
> ath10k patches look just like the others in the 34-patch series (bnx2,
> bnx2x, tg3, bna, cxgb3, etc.), so I thought it would make more sense
> to include them there.

ath10k patches normally go through my ath.git tree to Linville and then
to David Miller. To avoid conflicts I would prefer to take ath10k
patches to my tree whenever possible.

-- 
Kalle Valo

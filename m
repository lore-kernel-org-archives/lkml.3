Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaBLT2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:28:23 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54597 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaBLT2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:28:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140212133816.GB3147@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com> <ad5cc6d6bdf4c8f5ce4681ec27674d07fbda089e.1389904167.git.agordeev@redhat.com>
 <20140130134819.GA31909@dhcp-26-207.brq.redhat.com> <87y51qohjn.fsf@kamboji.qca.qualcomm.com>
 <20140204190935.GA1430@dhcp-26-207.brq.redhat.com> <8761oum0l3.fsf@kamboji.qca.qualcomm.com>
 <20140205085047.GA27820@dhcp-26-207.brq.redhat.com> <871tzilz1u.fsf@kamboji.qca.qualcomm.com>
 <20140212003143.GD21057@google.com> <20140212133816.GB3147@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 12 Feb 2014 12:28:00 -0700
Message-ID: <CAErSpo6c_EPc5c8aaTeD9=eXWw4OowcKhWHG6YZgTOkZRMtZHQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to pci_disable_msi()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 6:38 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Tue, Feb 11, 2014 at 05:31:43PM -0700, Bjorn Helgaas wrote:
>> I haven't put these in my branch, so you can take them.
>>
>> Alexander has a whole batch of network driver updates that I think David
>> Miller is going to apply; would it make sense to include these in that
>> batch?
>>
>> There's also the wil6210 patch for
>> drivers/net/wireless/ath/wil6210/pcie_bus.c, which seems like it maybe
>> could be in that batch, too.
>
> Well, as this series is small I thought it could quickly go thru your
> tree. But since ipr had conflicts, there is no point routing all patches
> altogether, so up to you guys. The wil6210 patch is already in your pci/msi
> branch though.

It's in pci/msi, but that's not in my -next branch yet, so I can
easily drop it.  Do drivers/net/wireless patches normally follow a
different path than the other drivers/net patches?  The wil6210 and
ath10k patches look just like the others in the 34-patch series (bnx2,
bnx2x, tg3, bna, cxgb3, etc.), so I thought it would make more sense
to include them there.

I think I need to put the ahci regression fix in v3.14, so I'll move
that to my for-linus branch and just keep the other odds and ends
(ahci and vfio) for v3.15.

Bjorn

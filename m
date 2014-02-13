Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaBMNQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:16:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaBMNQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:16:06 -0500
Date: Thu, 13 Feb 2014 14:18:02 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 1/3] ath10k: Get rid of superfluous call to
 pci_disable_msi()
Message-ID: <20140213131802.GA21757@dhcp-26-207.brq.redhat.com>
References: <20140130134819.GA31909@dhcp-26-207.brq.redhat.com>
 <87y51qohjn.fsf@kamboji.qca.qualcomm.com>
 <20140204190935.GA1430@dhcp-26-207.brq.redhat.com>
 <8761oum0l3.fsf@kamboji.qca.qualcomm.com>
 <20140205085047.GA27820@dhcp-26-207.brq.redhat.com>
 <871tzilz1u.fsf@kamboji.qca.qualcomm.com>
 <20140212003143.GD21057@google.com>
 <20140212133816.GB3147@dhcp-26-207.brq.redhat.com>
 <CAErSpo6c_EPc5c8aaTeD9=eXWw4OowcKhWHG6YZgTOkZRMtZHQ@mail.gmail.com>
 <87ppmsauij.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppmsauij.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:30:44PM +0200, Kalle Valo wrote:
> Bjorn Helgaas <bhelgaas@google.com> writes:
> 
> >> Well, as this series is small I thought it could quickly go thru your
> >> tree. But since ipr had conflicts, there is no point routing all patches
> >> altogether, so up to you guys. The wil6210 patch is already in your pci/msi
> >> branch though.
> >
> > It's in pci/msi, but that's not in my -next branch yet, so I can
> > easily drop it.  Do drivers/net/wireless patches normally follow a
> > different path than the other drivers/net patches?  The wil6210 and
> > ath10k patches look just like the others in the 34-patch series (bnx2,
> > bnx2x, tg3, bna, cxgb3, etc.), so I thought it would make more sense
> > to include them there.
> 
> ath10k patches normally go through my ath.git tree to Linville and then
> to David Miller. To avoid conflicts I would prefer to take ath10k
> patches to my tree whenever possible.

CC'ing Vladimir, in case he decides to do the same with wil6210.

> -- 
> Kalle Valo

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

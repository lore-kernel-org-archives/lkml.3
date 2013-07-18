Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab3GRSZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:25:45 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54270 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab3GRSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:25:42 -0400
Date: Thu, 18 Jul 2013 20:25:41 +0200
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: libata / IDE cs5536: 80c cable detect issue (and worse?)
Message-ID: <20130718182541.GA30707@rhlx01.hs-esslingen.de>
References: <20130718181355.GA31889@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718181355.GA31889@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

forgot to mention that I had already added a libata.force=40c boot
after my 80c config issue discovery
which did successfully cause the "limiting to UDMA/33 due to 40c foo" dmesg
yet where there's now initial but strong confirmation via reports
that the resulting UDMA/33 limit did NOT manage to fix corruption issues,
thus it's more strongly likely that the "bound to ill-suited pata_amd driver"
(due to incorrectly configuring speeds, or due to not configuring speeds
at all due to possibly BIOS not providing emulation of PCI register accesses
to Geode bus, which would be properly supported by pata_cs5536 OTOH)
thing is the actual reason and might fix it (fingers crossed).

Thanks,

Andreas Mohr

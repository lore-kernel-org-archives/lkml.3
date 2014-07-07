Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaGGVkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:40:16 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:21655
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750957AbaGGVkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:40:14 -0400
Date: Mon, 7 Jul 2014 16:19:32 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <a.motakis@virtualopensystems.com>, <alex.williamson@redhat.com>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <jhovold@gmail.com>,
        <will.deacon@arm.com>, <a.rigo@virtualopensystems.com>,
        <rob.herring@calxeda.com>, <stuart.yoder@freescale.com>,
        <rob@landley.net>, <grant.likely@linaro.org>,
        <tech@virtualopensystems.com>, <clbchenlibo.chen@huawei.com>,
        <christoffer.dall@linaro.org>, <eric.auger@linaro.org>,
        Julien Grall <julien.grall@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] driver core: platform: add device binding path
 'driver_override'
Message-ID: <20140707161932.e7ddaecd7cee53150694f022@freescale.com>
In-Reply-To: <20140603042842.GD14668@kroah.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
	<1398700371-20096-2-git-send-email-a.motakis@virtualopensystems.com>
	<20140602194258.5135925bf3c71b9c010fb409@freescale.com>
	<20140603042842.GD14668@kroah.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(164054003)(24454002)(51704005)(62966002)(68736004)(92566001)(92726001)(87286001)(76482001)(85306003)(81342001)(93886003)(84676001)(104166001)(105606002)(47776003)(64706001)(81542001)(19580395003)(44976005)(86362001)(23726002)(106466001)(83322001)(46102001)(33646001)(87936001)(77982001)(95666004)(99396002)(88136002)(97736001)(6806004)(93916002)(83072002)(74502001)(74662001)(46406003)(77156001)(31966008)(21056001)(80022001)(100306002)(36756003)(19580405001)(20776003)(85852003)(26826002)(104016002)(4396001)(79102001)(102836001)(89996001)(50466002)(76176999)(107046002)(50986999)(110136001)(50226001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB346;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014 21:28:42 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, Jun 02, 2014 at 07:42:58PM -0500, Kim Phillips wrote:
> > You are the platform driver core maintainer: can you apply this to
> > your driver-core tree now?
> 
> Yes, I will after this merge window ends, it's too late for 3.16-rc1
> with the window opening up a week early, sorry.

Hi Greg,

The merge window has ended, and I see commit activity on your
driver-core tree's driver-core-next branch, but this patch is still
missing:  Do you think you can get around to applying it before the
next merge window?

Thanks,

Kim

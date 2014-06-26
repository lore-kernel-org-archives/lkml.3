Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbaFZBNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:13:23 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:4798
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755871AbaFZBNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:13:21 -0400
Date: Wed, 25 Jun 2014 20:08:11 -0500
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
Message-ID: <20140625200811.9363cac92fdbc9810bf5aa65@freescale.com>
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
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(164054003)(199002)(24454002)(51704005)(189002)(4396001)(69596002)(84676001)(85306003)(93886003)(31966008)(74662001)(89996001)(99396002)(83072002)(26826002)(81156004)(86362001)(44976005)(6806004)(81342001)(19580395003)(83322001)(88136002)(19580405001)(81542001)(107046002)(106466001)(50226001)(76176999)(105606002)(104166001)(100306002)(97736001)(87286001)(93916002)(77156001)(50986999)(23726002)(36756003)(20776003)(64706001)(95666004)(92726001)(47776003)(46406003)(76482001)(79102001)(80022001)(92566001)(77982001)(33646001)(68736004)(85852003)(74502001)(87936001)(21056001)(62966002)(102836001)(104016002)(46102001)(50466002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB345;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02543CD7CD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
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

How about now?  fwiw, I just checked: it still applies cleanly.

Thanks,

Kim

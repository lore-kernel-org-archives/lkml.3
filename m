Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaJMN2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:28:44 -0400
Received: from mail-by2on0110.outbound.protection.outlook.com ([207.46.100.110]:19545
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753451AbaJMN2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:28:42 -0400
Date: Mon, 13 Oct 2014 08:23:24 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        <alex.williamson@redhat.com>, <tech@virtualopensystems.com>,
        <christoffer.dall@linaro.org>, <eric.auger@linaro.org>,
        <marc.zyngier@arm.com>
Subject: Re: [PATCH] driver core: amba: add device binding path
 'driver_override'
Message-ID: <20141013082324.362423be23ad44dc391ccd65@freescale.com>
In-Reply-To: <1413205672-6236-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205672-6236-1-git-send-email-a.motakis@virtualopensystems.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(51704005)(199003)(31966008)(100306002)(110136001)(102836001)(26826002)(97736003)(77156001)(62966002)(4396001)(50226001)(36756003)(104016003)(23726002)(33646002)(104166001)(46406003)(15975445006)(84676001)(92566001)(47776003)(20776003)(92726001)(76176999)(46102003)(21056001)(80022003)(44976005)(50986999)(64706001)(50466002)(15202345003)(19580395003)(19580405001)(6806004)(68736004)(69596002)(86362001)(93916002)(107046002)(99396003)(106466001)(120916001)(76482002)(81156004)(105606002)(95666004)(89996001)(87286001)(85852003)(87936001)(88136002)(85306004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:3;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Forefront-PRVS: 03630A6A4A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014 15:07:34 +0200
Antonios Motakis <a.motakis@virtualopensystems.com> wrote:

> As already demonstrated with PCI [1] and the platform bus [2], a
> driver_override property in sysfs can be used to bypass the id matching
> of a device to a AMBA driver. This can be used by VFIO to bind to any AMBA
> device requested by the user.
> 
> [1] http://lists-archives.com/linux-kernel/28030441-pci-introduce-new-device-binding-path-using-pci_dev-driver_override.html
> [2] https://www.redhat.com/archives/libvir-list/2014-April/msg00382.html
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---

Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Kim

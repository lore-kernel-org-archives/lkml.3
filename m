Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbaGDAl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 20:41:27 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:42406
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756385AbaGDAlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 20:41:19 -0400
Message-ID: <53B5F81B.8010801@freescale.com>
Date: Fri, 4 Jul 2014 06:10:59 +0530
From: Prabhakar Kushwaha <prabhakar@freescale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tanmay Inamdar <tinamdar@apm.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <liviu.dudau@arm.com>, <galak@codeaurora.org>
Subject: Re: [PATCH] arm64: PCI(e) arch support
References: <1404422876-1160-1-git-send-email-tinamdar@apm.com>
In-Reply-To: <1404422876-1160-1-git-send-email-tinamdar@apm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(479174003)(51704005)(377454003)(189002)(199002)(107046002)(74662001)(44976005)(36756003)(76176999)(54356999)(80022001)(83072002)(19580395003)(65956001)(69596002)(77982001)(33656002)(85852003)(21056001)(65816999)(6806004)(95666004)(83322001)(74502001)(83506001)(50986999)(104016002)(87266999)(99396002)(102836001)(80316001)(85306003)(68736004)(46102001)(65806001)(50466002)(20776003)(97736001)(92566001)(59896001)(64706001)(81542001)(76482001)(84676001)(86362001)(105606002)(64126003)(26826002)(106466001)(81156004)(31966008)(87936001)(81342001)(92726001)(23756003)(47776003)(4396001)(19580405001)(79102001)(2201001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB374;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02622CEF0A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=prabhakar@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tanmay, Liviu,
On 7/4/2014 2:57 AM, Tanmay Inamdar wrote:
> Reposting on request of several people since previously posted one was
> corrupted.
>
> This patch adds the arch support for PCI(e) for arm64. The files
> added or modified in this patch are based on PCI(e) support in
> 32bit arm.
>
> Please note that this patch is just for the reference. Liviu Dudau from ARM
> has posted his v8 series of patch to support PCIe in arm64.
>
> The patch will apply against 3.13 Linux Kernel
>
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>

do we foresee similar type of changes in u-boot  to support PCI(e) for 
ARM64.

Regards,
Prabhakar



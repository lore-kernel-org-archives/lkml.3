Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422731AbaJaBh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:37:26 -0400
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:50692
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422652AbaJaBhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:37:23 -0400
X-WSS-ID: 0NEACI2-08-CQI-02
X-M-MSG: 
Date: Fri, 31 Oct 2014 09:29:55 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 14/20] usb: dwc3: add Tx de-emphasis quirk
Message-ID: <20141031012954.GA20367@hr-slim.amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-15-git-send-email-ray.huang@amd.com>
 <20141030164210.GM10130@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141030164210.GM10130@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(164054003)(189002)(199003)(51704005)(97736003)(68736004)(107046002)(77096002)(95666004)(85306004)(76176999)(53416004)(110136001)(106466001)(20776003)(47776003)(50466002)(64706001)(105586002)(19580395003)(19580405001)(21056001)(44976005)(4396001)(120916001)(23726002)(85852003)(86362001)(92566001)(80022003)(92726001)(101416001)(46406003)(31966008)(54356999)(50986999)(97756001)(84676001)(83506001)(46102003)(33656002)(76482002)(102836001)(99396003)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 11:42:10AM -0500, Felipe Balbi wrote:
> On Thu, Oct 30, 2014 at 06:08:39PM +0800, Huang Rui wrote:
> > This patch adds Tx de-emphasis quirk, and the Tx de-emphasis value is
> > configurable according to PIPE3 specification.
> > 
> > Value		Description
> > 0		-6dB de-emphasis
> > 1		-3.5dB de-emphasis
> > 2		No de-emphasis
> > 3		Reserved
> > 
> > It can be configured on DT or platform data.
> > 
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> 
> doesn't apply:
> 
> checking file Documentation/devicetree/bindings/usb/dwc3.txt
> checking file drivers/usb/dwc3/core.c
> Hunk #2 succeeded at 718 (offset -2 lines).
> Hunk #3 succeeded at 777 (offset -2 lines).
> Hunk #4 succeeded at 807 (offset -2 lines).
> Hunk #5 succeeded at 829 (offset -2 lines).
> Hunk #6 succeeded at 840 (offset -2 lines).
> checking file drivers/usb/dwc3/core.h
> Hunk #2 FAILED at 697.
> 1 out of 3 hunks FAILED
> checking file drivers/usb/dwc3/platform_data.h
> 
> please rebase on testing/next
> 

That's because in patch 12 and other ones you applied, I changed
addreviations to uppercase such as "lfps" -> "LFPS", "fpga" -> "FPGA".

Previous 13 patches are already applied. Do you mean, I send the other
patches since "Tx de-emphasis" (patch 14) after rebased current
branch.

If yes, at patch 1, "Enabling this bit ... hibernation .. yet", should
it be updated in extra patch?

Thanks,
Rui

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbaJ3Ll4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:41:56 -0400
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:56832
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759254AbaJ3Lly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:41:54 -0400
X-WSS-ID: 0NE99TN-08-MG7-02
X-M-MSG: 
Date: Thu, 30 Oct 2014 19:36:27 +0800
From: Huang Rui <ray.huang@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 01/20] usb: dwc3: enable hibernation if to be supported
Message-ID: <20141030113627.GA15526@hr-slim.amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
 <1414663725-2195-2-git-send-email-ray.huang@amd.com>
 <4077930.b7qzaS4pBb@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4077930.b7qzaS4pBb@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(51704005)(164054003)(24454002)(76176999)(50986999)(92726001)(92566001)(97756001)(85852003)(86362001)(54356999)(19580395003)(87936001)(46406003)(64706001)(20776003)(4396001)(68736004)(47776003)(77096002)(120916001)(50466002)(84676001)(83506001)(15975445006)(15202345003)(107046002)(76482002)(23726002)(21056001)(80022003)(19580405001)(31966008)(106466001)(46102003)(102836001)(97736003)(99396003)(44976005)(33656002)(95666004)(53416004)(110136001)(105586002)(85306004)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:35:56PM +0100, Arnd Bergmann wrote:
> On Thursday 30 October 2014 18:08:26 Huang Rui wrote:
> > It enables hibernation if the function is set in coreConsultant.
> > 
> > Suggested-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > 
> 
> Something went wrong with the Signed-off-by lines here. 
> You should never add someone else's Signed-off-by below yours.
> 
> I took a brief look at the entire series and the patches all look good
> to me, but you have made the same mistake with the Signed-off-by
> multiple times.
> 

Actually, this patch is applied at testing branch, so Felipe added his
Signed-off-by. Please see:

http://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/commit/?h=testing/next&id=5c9669f92c9441d134f7776274e9afb71c246acc

I just update some comment description in V4.

Thanks,
Rui

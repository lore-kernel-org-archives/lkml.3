Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaJ2GwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:52:16 -0400
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:45904
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbaJ2GwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:52:14 -0400
X-WSS-ID: 0NE71QW-07-NNR-02
X-M-MSG: 
Date: Wed, 29 Oct 2014 14:50:55 +0800
From: Huang Rui <ray.huang@amd.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/19] usb: dwc3: add disscramble quirk
Message-ID: <20141029065055.GA8935@hr-slim.amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-5-git-send-email-ray.huang@amd.com>
 <CAErSpo5vRcGxu=e61tCEwNVL913_Lxne=1KW+JtQVpc6jgCaHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAErSpo5vRcGxu=e61tCEwNVL913_Lxne=1KW+JtQVpc6jgCaHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(51704005)(189002)(377454003)(199003)(24454002)(33656002)(85852003)(4396001)(102836001)(19580395003)(46102003)(19580405001)(44976005)(80022003)(92726001)(97756001)(31966008)(92566001)(86362001)(54356999)(110136001)(87936001)(46406003)(76176999)(23726002)(50986999)(97736003)(21056001)(105586002)(85306004)(95666004)(20776003)(47776003)(83506001)(50466002)(106466001)(64706001)(99396003)(120916001)(76482002)(53416004)(77096002)(84676001)(107046002)(101416001)(68736004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Tue, Oct 28, 2014 at 10:39:26AM -0600, Bjorn Helgaas wrote:
> On Tue, Oct 28, 2014 at 5:54 AM, Huang Rui <ray.huang@amd.com> wrote:
> > This patch adds disscramble quirk, and it only needs to be enabled at fpga
> 
> "disscramble" (in subject and above) is not a real word.
> 
> I see that DWC3_GCTL_DISSCRAMBLE is already defined in
> drivers/usb/dwc3/core.h even before your patches, so I suppose it's
> something the hardware designers made up.
> 
> Maybe it means "descramble" (or "unscramble").  Or maybe it means
> "disable scrambling"?  A comment might make this clearer.  A better
> name would be even better.
> 

Your mention is right. "disscramble" is writed by HW designers in
DesignWare databook. It could confuse reader, I will update subject
and add note (disscramble = disable scramble) at commit log.

Thanks,
Rui

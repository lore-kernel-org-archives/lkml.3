Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbaJ2Hpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:45:41 -0400
Received: from mail-bl2on0147.outbound.protection.outlook.com ([65.55.169.147]:52608
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752843AbaJ2Hpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:45:39 -0400
X-WSS-ID: 0NE747Y-08-055-02
X-M-MSG: 
Date: Wed, 29 Oct 2014 15:44:16 +0800
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
Subject: Re: [PATCH v3 05/19] usb: dwc3: add lpm erratum support
Message-ID: <20141029074416.GA10840@hr-slim.amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-6-git-send-email-ray.huang@amd.com>
 <CAErSpo7JeiJSD+-XAMZH+D8r9Knkq80KPUroYYbqak6EQ6f4RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAErSpo7JeiJSD+-XAMZH+D8r9Knkq80KPUroYYbqak6EQ6f4RA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(24454002)(51704005)(479174003)(377454003)(164054003)(95666004)(106466001)(99396003)(120916001)(50986999)(76176999)(54356999)(87936001)(97756001)(107046002)(85306004)(105586002)(85852003)(20776003)(46406003)(101416001)(92726001)(92566001)(19580405001)(19580395003)(68736004)(110136001)(102836001)(76482002)(50466002)(4396001)(80022003)(21056001)(83506001)(77096002)(86362001)(84676001)(64706001)(31966008)(46102003)(23726002)(33656002)(53416004)(47776003)(44976005)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:30:50AM -0600, Bjorn Helgaas wrote:
> On Tue, Oct 28, 2014 at 5:54 AM, Huang Rui <ray.huang@amd.com> wrote:
> > When parameter DWC_USB3_LPM_ERRATA_ENABLE is enabled in Andvanced
> 
> "Advanced"
> 
> > Configuration of coreConsultant, it supports of xHCI BESL Errata Dated
> 
> I can't parse "is supports of" and I don't know enough to suggest an
> alternate wording.
> 
> > 10/19/2011 is enabled in host mode. In device mode it adds the capability
> > to send NYET response threshold based on the BESL value received in the LPM
> > token, and the threhold is configurable for each soc platform.
> 
> "threshold"
> 

Thanks to reminder.

It should be:
When parameter DWC_USB3_LPM_ERRATA_ENABLE is enabled in Advanced
Configuration of coreConsultant, support of xHCI BESL Errata Dated
10/19/2011 is enabled in host mode. In device mode it adds the
capability to send NYET response threshold based on the BESL value
received in the LPM token, and the threshold is configurable for each
SoC platform.

Thanks,
Rui

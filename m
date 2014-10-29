Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaJ2IJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:09:59 -0400
Received: from mail-bn1bon0146.outbound.protection.outlook.com ([157.56.111.146]:10992
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755363AbaJ2IJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:09:52 -0400
X-WSS-ID: 0NE75C9-07-QJE-02
X-M-MSG: 
Date: Wed, 29 Oct 2014 16:08:09 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 13/19] usb: dwc3: add tx demphasis quirk
Message-ID: <20141029080809.GB10840@hr-slim.amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
 <1414497280-3126-14-git-send-email-ray.huang@amd.com>
 <CAErSpo6ouE7AZi8ysTFnTNtKc8R9w-71AhXe6b-_0g_yeR-=Ag@mail.gmail.com>
 <20141028184303.GD25735@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141028184303.GD25735@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(24454002)(51704005)(199003)(377454003)(105586002)(106466001)(95666004)(110136001)(101416001)(107046002)(97736003)(50986999)(76176999)(54356999)(68736004)(83506001)(33656002)(102836001)(99396003)(120916001)(31966008)(93886004)(85306004)(4396001)(64706001)(86362001)(20776003)(23726002)(47776003)(46102003)(80022003)(50466002)(85852003)(19580395003)(19580405001)(76482002)(92566001)(92726001)(46406003)(44976005)(77096002)(21056001)(53416004)(84676001)(97756001)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:43:03PM -0500, Felipe Balbi wrote:
> On Tue, Oct 28, 2014 at 10:27:27AM -0600, Bjorn Helgaas wrote:
> > On Tue, Oct 28, 2014 at 5:54 AM, Huang Rui <ray.huang@amd.com> wrote:
> > > This patch adds Tx demphasis quirk, and the Tx demphasis value is
> > 
> > "demphasis" (above and in subject) should be "de-emphasis" as used in
> > the code and comments below.
> 
> +1
> 

OK, will update

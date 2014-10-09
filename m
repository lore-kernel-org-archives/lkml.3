Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaJIGX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:23:29 -0400
Received: from mail-bn1bon0060.outbound.protection.outlook.com ([157.56.111.60]:40873
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbaJIGXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:23:20 -0400
X-Greylist: delayed 76684 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2014 02:23:20 EDT
Date: Thu, 9 Oct 2014 08:23:01 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Goutham <sgoutham@cavium.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree
 bindings
Message-ID: <20141009062301.GJ31556@rric.localhost>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <1411573068-12952-4-git-send-email-rric@kernel.org>
 <3082935.e3X4GsVUDn@wuerfel>
 <20141007142744.GE31556@rric.localhost>
 <20141007150149.GW4652@e106497-lin.cambridge.arm.com>
 <20141008084927.GH31556@rric.localhost>
 <20141008164432.GC15382@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141008164432.GC15382@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.199.47]
X-ClientProxiedBy: AMSPR04CA0050.eurprd04.prod.outlook.com (10.242.87.168) To
 BLUPR0701MB802.namprd07.prod.outlook.com (10.141.253.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR0701MB802;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(6069001)(199003)(24454002)(189002)(51704005)(97736003)(76506005)(106356001)(97756001)(102836001)(20776003)(47776003)(46406003)(86362001)(575784001)(4396001)(105586002)(50986999)(110136001)(93886004)(85306004)(107046002)(31966008)(76176999)(54356999)(33656002)(101416001)(95666004)(46102003)(77096002)(42186005)(80022003)(92726001)(92566001)(76482002)(21056001)(23726002)(120916001)(99396003)(87976001)(50466002)(66066001)(85852003)(64706001)(122386002)(83506001)(40100002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR0701MB802;H:rric.localhost;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.14 17:44:32, Liviu Dudau wrote:
> On Wed, Oct 08, 2014 at 09:49:27AM +0100, Robert Richter wrote:
> > On 07.10.14 16:01:49, Liviu Dudau wrote:
> > I am quite confused a bit on which is the latest code base now. I was
> > looking into Bjorn's pci/host-generic and there is a different
> > implemetation:

> > This differs also from v13. Please check.

> I'm not sure what you are looking at. Commit 41e5c0f81d3e does look like
> my v13. Not sure why you are still seeing this v11 version.

Right, my bad. Sorry for the noise.

-Robert

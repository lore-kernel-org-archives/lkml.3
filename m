Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbaJaQbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:31:55 -0400
Received: from mail-by2on0071.outbound.protection.outlook.com ([207.46.100.71]:43456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750797AbaJaQbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:31:53 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 12:31:53 EDT
Date: Fri, 31 Oct 2014 17:17:24 +0100
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Stephen Hemminger <stephen@networkplumber.org>
CC: Robert Richter <rric@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@cavium.com>,
        Stefan Assmann <sassmann@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] VNIC: Adding support for Cavium ThunderX network
 controller
Message-ID: <20141031161724.GC31556@rric.localhost>
References: <20141030165434.GW20170@rric.localhost>
 <20141030194513.089d27ec@urahara>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141030194513.089d27ec@urahara>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.195.136]
X-ClientProxiedBy: AMSPR04CA0036.eurprd04.prod.outlook.com (10.242.87.154) To
 DM2PR0701MB809.namprd07.prod.outlook.com (10.242.127.23)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0701MB809;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6069001)(51704005)(24454002)(189002)(199003)(40100003)(83506001)(21056001)(54356999)(105586002)(97736003)(87976001)(101416001)(64706001)(20776003)(47776003)(33656002)(102836001)(4396001)(42186005)(110136001)(46406003)(107046002)(106356001)(76176999)(120916001)(50986999)(95666004)(97756001)(99396003)(31966008)(76506005)(23726002)(92566001)(86362001)(92726001)(19580395003)(19580405001)(46102003)(50466002)(66066001)(122386002)(77156002)(62966003)(77096003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0701MB809;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0701MB1248;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.10.14 19:45:13, Stephen Hemminger wrote:
> On Thu, 30 Oct 2014 17:54:34 +0100
> Robert Richter <rric@kernel.org> wrote:
> 
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index 1fa99a301817..80bd3336691e 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2324,6 +2324,8 @@
> >  #define PCI_DEVICE_ID_ALTIMA_AC9100	0x03ea
> >  #define PCI_DEVICE_ID_ALTIMA_AC1003	0x03eb
> >  
> > +#define PCI_VENDOR_ID_CAVIUM		0x177d
> 
> I don't think PCI folks want this updated with every id anymore.

This is just the vendor id, the device id is part of the driver.

Since there will be multiple drivers I put the vendor id here.

-Robert

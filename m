Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaJAVRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:17:10 -0400
Received: from mail-by2on0107.outbound.protection.outlook.com ([207.46.100.107]:51552
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751268AbaJAVRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:17:08 -0400
Date: Wed, 1 Oct 2014 14:16:57 -0700
From: Guenter Roeck <groeck@juniper.net>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Danielle Costantino <danielle.costantino@gmail.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Subject: Re: Fwd: [Proposal] PM sleep children of inactive I2C bus segments
 off Masters in multi-master systems
Message-ID: <20141001211657.GA7904@svl-evodev-groeck.juniper.net>
References: <CAAVjN7dwS62EKMnuZc_P1UjkbRVk6RXqJ91GwWZ96bbY5Ct-rg@mail.gmail.com>
 <CAAVjN7eUmBVcAGPbcn3qsJ9M9uu2nkFoKHqGhhKGekZSceGiMw@mail.gmail.com>
 <20141001184304.GA6832@svl-evodev-groeck.juniper.net>
 <CAAVjN7edpkXYMHBm+wLegA_pc0hnm_YZf_z=Ni3h=EbDTmfegQ@mail.gmail.com>
 <20141001194115.GA6948@svl-evodev-groeck.juniper.net>
 <CAAVjN7fGRzyu7gxavJUay+K_Mm-0t1T_0Bysk6-sdaqu5=5k5A@mail.gmail.com>
 <20141001202058.GB6948@svl-evodev-groeck.juniper.net>
 <CAAVjN7e4nO579TfAJ5zMNe__Q9yU_-6naq4-0vm1rimespSrsw@mail.gmail.com>
 <20141001204302.GA7744@svl-evodev-groeck.juniper.net>
 <20141001211046.GA2368@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141001211046.GA2368@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [66.129.239.11]
X-ClientProxiedBy: CO1PR06CA046.namprd06.prod.outlook.com (10.242.160.36) To
 BLUPR05MB514.namprd05.prod.outlook.com (10.141.29.142)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR05MB514;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6069001)(189002)(199003)(24454002)(51704005)(47776003)(20776003)(31966008)(64706001)(50986999)(50466002)(66066001)(97736003)(77096002)(46406003)(76506005)(42186005)(76176999)(107046002)(101416001)(97756001)(102836001)(54356999)(83506001)(33656002)(86362001)(87976001)(4396001)(85852003)(80022003)(120916001)(110136001)(106356001)(95666004)(92566001)(46102003)(105586002)(10300001)(21056001)(76482002)(23726002)(92726001)(85306004)(93886004)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR05MB514;H:localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 11:10:47PM +0200, Wolfram Sang wrote:
> 
> > Maybe you can find an error code which with some level of confidence
> > reflects "lost mastership". Then you can implement whatever makes sense
> > for your use case in your user space application(s).
> 
> We have a documented fault code for ArbitrationLost and that is -EAGAIN
> (see Documentation/i2c/fault-codes). If a driver does use something
> else, patches are very welcome.
> 
> Other than that, I find this thread very confusing. Of course can
> another master modify the clients, this is what multi-master is all
> about, no?
> 
That is the point I was trying to make in one of my earlier replies.

Guenter

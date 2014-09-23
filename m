Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaIWLGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:06:19 -0400
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:9568
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753694AbaIWLGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:06:18 -0400
X-Greylist: delayed 889 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 07:06:18 EDT
Date: Tue, 23 Sep 2014 12:51:08 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>
CC: Robert Richter <rric@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64, defconfig: Increase NR_CPUS default to 64
Message-ID: <20140923105108.GS31556@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140923104716.GG26472@arm.com>
 <20140923104656.GA24822@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [78.53.83.147]
X-ClientProxiedBy: AM2PR02CA0017.eurprd02.prod.outlook.com (25.160.28.155) To
 CO2PR0701MB807.namprd07.prod.outlook.com (10.141.246.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR0701MB807;
X-Forefront-PRVS: 0343AC1D30
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6069001)(199003)(51704005)(189002)(24454002)(51914003)(66066001)(54356999)(50986999)(90102001)(101416001)(106356001)(64706001)(33656002)(23726002)(99396002)(85306004)(20776003)(47776003)(87976001)(102836001)(46102003)(97736003)(86362001)(46406003)(77096002)(76482002)(85852003)(74662003)(83072002)(74502003)(4396001)(77982003)(81342003)(31966008)(81542003)(50466002)(42186005)(95666004)(92566001)(97756001)(15975445006)(76506005)(21056001)(107046002)(80022003)(120916001)(92726001)(83506001)(105586002)(19580395003)(79102003)(83322001)(10300001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR0701MB807;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.09.14 11:46:56, Mark Rutland wrote:
> On Tue, Sep 23, 2014 at 11:44:31AM +0100, Robert Richter wrote:
> > On 08.09.14 13:44:48, Robert Richter wrote:
> > Catalin, Will,
> > 
> > please consider applying this patch.
> 
> This is already in the arm64 for-next/core branch [1].
> 
> Mark.
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/arm64/linux.git/commit/?h=for-next/core&id=e3672649faae400e8a598938766a63f395a27ae6

Ah, thanks for the pointer.

-Robert

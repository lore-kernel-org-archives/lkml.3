Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaIKPGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:06:33 -0400
Received: from mail-bn1on0059.outbound.protection.outlook.com ([157.56.110.59]:53120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751649AbaIKPGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:06:31 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 11:06:31 EDT
Date: Thu, 11 Sep 2014 16:51:09 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Robert Richter <rric@kernel.org>, Will Deacon <will.deacon@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Radha Mohan Chintakuntla" <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] arm64, thunder: Add initial dts for Cavium
 Thunder SoC
Message-ID: <20140911145109.GJ10622@rric.localhost>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <1409903205-2762-3-git-send-email-rric@kernel.org>
 <5017180.kZRPNE71Sv@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5017180.kZRPNE71Sv@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [78.53.80.73]
X-ClientProxiedBy: DB4PR07CA037.eurprd07.prod.outlook.com (10.242.229.47) To
 SN2PR0701MB813.namprd07.prod.outlook.com (25.160.16.147)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6069001)(6009001)(24454002)(199003)(189002)(51704005)(46406003)(97756001)(74502001)(33656002)(90102001)(106356001)(74662001)(77096002)(83506001)(76482001)(85306004)(20776003)(4396001)(19580395003)(76176999)(92566001)(80022001)(102836001)(85852003)(50466002)(95666004)(31966008)(66066001)(54356999)(42186005)(79102001)(64706001)(107046002)(86362001)(99396002)(77982001)(81542001)(105586002)(83072002)(101416001)(76506005)(23726002)(110136001)(97736003)(87976001)(83322001)(47776003)(50986999)(92726001)(21056001)(46102001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR0701MB813;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 05.09.14 13:21:48, Arnd Bergmann wrote:
> On Friday 05 September 2014 09:46:43 Robert Richter wrote:
> > diff --git a/arch/arm64/boot/dts/thunder-88xx.dts b/arch/arm64/boot/dts/thunder-88xx.dts
> > new file mode 100644
> > index 000000000000..4cc1d059d2d9
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/thunder-88xx.dts
> 
> Most people end up having a soc.dtsi file and a board.dsi file including
> the former and adding the machine-specific properties.

thanks for your feedback on the dts file. I already included your
suggestion into the patches and split the files.

-Robert

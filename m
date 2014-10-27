Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaJ0OaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:30:08 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:46624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752930AbaJ0OaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:30:06 -0400
X-WSS-ID: 0NE3XLY-07-0U7-02
X-M-MSG: 
Message-ID: <544E56DB.7020305@amd.com>
Date: Mon, 27 Oct 2014 09:29:47 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
 <544C2D67.8000405@suse.de> <544CEC5B.4020104@suse.de>
 <A1BC53C1-A78E-4B0C-879B-F6A462E58C72@suse.de>
In-Reply-To: <A1BC53C1-A78E-4B0C-879B-F6A462E58C72@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174003)(377454003)(24454002)(51704005)(189002)(199003)(65956001)(65806001)(4396001)(64126003)(80022003)(46102003)(97736003)(85852003)(87936001)(107046002)(105586002)(95666004)(106466001)(85306004)(93886004)(68736004)(83506001)(44976005)(54356999)(87266999)(50986999)(65816999)(84676001)(23676002)(50466002)(80316001)(76176999)(33656002)(120916001)(76482002)(102836001)(21056001)(86362001)(92566001)(120886001)(99396003)(31966008)(36756003)(64706001)(92726001)(101416001)(20776003)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2014 9:08 AM, Alexander Graf wrote:
>>> This option doesn't exist in upstream kernels, does it? Why not just
>>> >>make it dtb-y?
>> >
>> >CONFIG_ARCH_SEATTLE is being added one hunk above.:)
> Oops:).
>
> I'm not convinced we need a config option just for the sake of compiling a device tree though.
>
>
> Alex
>

Eventually, we would add other device driver selections when 
CONFIG_ARCH_SEATTLE=y. At this point, those drivers are still not ready.

Suravee



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaKHS7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:59:20 -0500
Received: from mail-bn1bon0142.outbound.protection.outlook.com ([157.56.111.142]:11625
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754049AbaKHS7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:59:18 -0500
X-WSS-ID: 0NEQI2K-08-GKG-02
X-M-MSG: 
Message-ID: <545E67F4.4000706@amd.com>
Date: Sat, 8 Nov 2014 20:59:00 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        David Rientjes <rientjes@google.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Sebastian Reichel <sre@debian.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH v5 06/24] Update MAINTAINERS and CREDITS files with amdkfd
 info
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
	 <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
 <1415472403.23530.28.camel@perches.com>
In-Reply-To: <1415472403.23530.28.camel@perches.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(479174003)(189002)(377454003)(377424004)(199003)(62966003)(99396003)(46102003)(65806001)(65956001)(77156002)(106466001)(31966008)(105586002)(21056001)(87936001)(20776003)(47776003)(120916001)(110136001)(107046002)(97736003)(87266999)(50986999)(54356999)(65816999)(102836001)(76176999)(33656002)(101416001)(44976005)(19580395003)(19580405001)(80316001)(59896002)(68736004)(84676001)(83506001)(23676002)(64126003)(92726001)(64706001)(95666004)(4396001)(50466002)(86362001)(36756003)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/08/2014 08:46 PM, Joe Perches wrote:
> On Sat, 2014-11-08 at 20:37 +0200, Oded Gabbay wrote:
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -610,6 +610,16 @@ F:	drivers/crypto/geode*
>>  F:	drivers/video/fbdev/geode/
>>  F:	arch/x86/include/asm/geode.h
>>  
>> +AMD KFD (radeon extension)
>> +M:	Oded Gabbay <oded.gabbay@amd.com>
>> +L:	dri-devel@lists.freedesktop.org
>> +T:	git git://people.freedesktop.org/~gabbayo/linux.git
>> +S:	Supported
>> +F:	drivers/gpu/drm/radeon/amdkfd/*
>> +F:	drivers/gpu/drm/radeon/radeon_kfd.c
>> +F:	drivers/gpu/drm/radeon/radeon_kfd.h
>> +F:	include/linux/uapi/linux/kfd_ioctl.h
> 
> include/uapi/linux/kfd_ioctl.h
> 
>> +
>>  AMD IOMMU (AMD-VI)
>>  M:	Joerg Roedel <joro@8bytes.org>
>>  L:	iommu@lists.linux-foundation.org
> 
> Please keep MAINTAINERS in alphabetical order too.
> Move this new AMD KFD section after AMD IOMMU.
> 

Thanks for the comments. Will be fixed in next version.
I also noticed I forgot to modify drivers/gpu/drm/radeon/amdkfd/* to
drivers/gpu/drm/amd/amdkfd/*

	Oded

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaGQLzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:55:52 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:52576
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754920AbaGQLzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:55:50 -0400
X-WSS-ID: 0N8UUGV-08-1FH-02
X-M-MSG: 
Message-ID: <53C7B9B5.6070208@amd.com>
Date: Thu, 17 Jul 2014 14:55:33 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, Joe Perches <joe@perches.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 04/83] drm/radeon: Add radeon <--> kfd interface
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-3-git-send-email-oded.gabbay@amd.com>
	 <1405031913.2796.7.camel@joe-AO725> <20140711162424.GE1870@gmail.com>
In-Reply-To: <20140711162424.GE1870@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(479174003)(377424004)(24454002)(199002)(189002)(74502001)(31966008)(74662001)(106466001)(107046002)(21056001)(85306003)(81542001)(83072002)(85852003)(87936001)(81342001)(4396001)(77982001)(59896001)(79102001)(46102001)(92726001)(97736001)(76482001)(84676001)(64126003)(33656002)(83506001)(36756003)(83322001)(105586002)(95666004)(68736004)(44976005)(76176999)(93886003)(54356999)(50466002)(87266999)(65806001)(47776003)(80022001)(64706001)(101416001)(102836001)(99396002)(50986999)(92566001)(86362001)(23756003)(65816999)(20776003)(65956001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB034;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/14 19:24, Jerome Glisse wrote:
> On Thu, Jul 10, 2014 at 03:38:33PM -0700, Joe Perches wrote:
>> On Fri, 2014-07-11 at 00:50 +0300, Oded Gabbay wrote:
>>> This patch adds the interface between the radeon driver and the kfd
>>> driver. The interface implementation is contained in
>>> radeon_kfd.c and radeon_kfd.h.
>> []
>>>   include/linux/radeon_kfd.h          | 67 ++++++++++++++++++++++++++
>>
>> Is there a good reason to put this file in include/linux?
>>
>
> Agrees, we do not want to clutter include/linux/ with specific driver
> include, i think its one of the rules even thought there is some hw header
> already in there.
>
> I would rather see either a new dir include/hsa or inside include/drm.
>
> Cheers,
> Jérôme
>

Moved to drm/radeon in v2 of the patchset
	Oded

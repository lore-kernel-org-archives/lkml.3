Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab3BQTQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:16:19 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.91]:10284 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789Ab3BQTQS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:16:18 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2013 14:16:17 EST
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Topic: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Index: AQHOC6xQKsSDc1Q1WkuxN29CXfjd55h+pfaA///G/Yw=
Date: Sun, 17 Feb 2013 19:10:28 +0000
Message-ID: <a9aa48c6abf3441e9f3a4481d154319f@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>,<20130217143223.GA11543@aepfle.de>
In-Reply-To: <20130217143223.GA11543@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(164054002)(24454001)(377454001)(53806001)(54356001)(51856001)(4396001)(49866001)(80022001)(66066001)(65816001)(876001)(77982001)(59766001)(20776003)(76482001)(56776001)(5343655001)(46406002)(63696002)(47776003)(56816002)(54316002)(79102001)(44976002)(23726001)(31966008)(46102001)(74662001)(33646001)(16406001)(50466001)(47976001)(74502001)(47446002)(47736001)(50986001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2SR01MB604;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 07607ED19A
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Olaf Hering
> Sent: Sunday, February 17, 2013 9:32 AM
> To: Haiyang Zhang
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org; KY Srinivasan; jasowang@redhat.com; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer Driver

> On Fri, Feb 15, Haiyang Zhang wrote:

> +config HYPERV_FB

> This should probably be FB_HYPERB to follow the naming of all other
> drivers.

Will do.

Thanks,
- Haiyang

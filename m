Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab3CLRHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:07:30 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.88]:24507 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932709Ab3CLRH2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:07:28 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH v3] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Topic: [PATCH v3] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Index: AQHOHEJT0pDaVqYkYUWJ2EJCMDMDQZiiTfZA
Date: Tue, 12 Mar 2013 17:06:56 +0000
Message-ID: <df124c4a0bc945c9a667dc603b99951a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1362779141-9612-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1362779141-9612-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704002)(164054002)(13464002)(189002)(199002)(76482001)(47446002)(16406001)(66066001)(23726001)(46406002)(80022001)(33646001)(54316002)(56776001)(44976002)(74662001)(50986001)(50466001)(77982001)(65816001)(876001)(31966008)(69226001)(4396001)(59766001)(74502001)(49866001)(56816002)(79102001)(20776003)(47736001)(47776003)(47976001)(5343655001)(5343635001)(51856001)(46102001)(53806001)(63696002)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2SR01MB608;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 078310077C
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Haiyang Zhang
> Sent: Friday, March 08, 2013 4:46 PM
> To: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org
> Cc: Haiyang Zhang; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com;
> linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: [PATCH v3] video: Add Hyper-V Synthetic Video Frame Buffer
> Driver
> 
> This is the driver for the Hyper-V Synthetic Video, which supports
> screen
> resolution up to Full HD 1920x1080 on Windows Server 2012 host, and
> 1600x1200
> on  Windows Server 2008 R2 or earlier.
> It also solves the double mouse cursor issue of the emulated video mode.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 

Hi, Florian and Andrew,

So far, I have responded to all comments from the community, and made the
recommended updates. Do you have any additional comments on this driver?

Thanks,
- Haiyang


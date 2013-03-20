Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3CTOaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:30:07 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.92]:54574 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab3CTOaG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:30:06 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: linux-next: manual merge of the akpm tree with the char-misc
 tree
Thread-Topic: linux-next: manual merge of the akpm tree with the char-misc
 tree
Thread-Index: AQHOJSJm3/YRQxaQy0OOj96TXXjnsJiupBFw
Date: Wed, 20 Mar 2013 14:29:26 +0000
Message-ID: <960b30d6dde3492b81120985e28ff061@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
References: <20130320152007.56de4a48eaf2760ccc07f02b@canb.auug.org.au>
In-Reply-To: <20130320152007.56de4a48eaf2760ccc07f02b@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464002)(377454001)(199002)(189002)(23726001)(54356001)(80022001)(16406001)(66066001)(50466001)(65816001)(69226001)(47976001)(49866001)(31966008)(33646001)(47446002)(46102001)(74502001)(74662001)(44976002)(79102001)(54316002)(51856001)(47736001)(53806001)(50986001)(20776003)(47776003)(63696002)(56816002)(59766001)(46406002)(56776001)(876001)(4396001)(77982001)(76482001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:CH1SR01MB612;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 07915F544A
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Wednesday, March 20, 2013 12:20 AM
> To: Andrew Morton
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Haiyang
> Zhang; KY Srinivasan; Greg KH; Arnd Bergmann
> Subject: linux-next: manual merge of the akpm tree with the char-misc
> tree
> 
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> include/linux/hyperv.h between commit 96dd86fa5881 ("Drivers: hv: Add a
> new driver to support host initiated backup") from the char-misc  tree
> and commit "drivers/video: add Hyper-V Synthetic Video Frame Buffer
> Driver" from the akpm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thank you for fixing it!

- Haiyang

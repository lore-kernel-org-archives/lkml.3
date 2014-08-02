Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaHBQTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 12:19:12 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:37568
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754489AbaHBQTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 12:19:10 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: net-next: hyperv: Increase the size of the
 sendbuf region
Thread-Topic: [PATCH 1/1] Drivers: net-next: hyperv: Increase the size of the
 sendbuf region
Thread-Index: AQHPrFcl/pZ15J3jR0S9Ym/gWYDpuJu7MfeAgADTGUCAANQ1gIAAqIsA
Date: Sat, 2 Aug 2014 16:18:54 +0000
Message-ID: <bb5fea25ef364ad79f82017ad9f2405f@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1406770549-29982-1-git-send-email-kys@microsoft.com>
	<20140731.215907.860867918938148695.davem@davemloft.net>
	<e19aea30a421423090ba63db9ff8e0af@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140801.231411.84176925721916363.davem@davemloft.net>
In-Reply-To: <20140801.231411.84176925721916363.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:577:75ee:7a18:f7ed]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(13464003)(189002)(199002)(92566001)(85852003)(110136001)(87936001)(83072002)(19580395003)(83322001)(2656002)(80022001)(4396001)(107046002)(105586002)(106356001)(106116001)(95666004)(99286002)(33646002)(54356999)(99396002)(46102001)(81542001)(81342001)(76176999)(50986999)(86612001)(19580405001)(21056001)(85306004)(74662001)(74502001)(31966008)(76482001)(74316001)(79102001)(76576001)(77982001)(64706001)(93886004)(86362001)(101416001)(77096002)(20776003)(24736002)(3826002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, August 1, 2014 11:14 PM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: net-next: hyperv: Increase the size of the
> sendbuf region
> 
> 
> Don't explain things to me in this thread.
> 
> Instead, tell the whole world and everyone who would ever see this commit,
> in the commit log message.
Will do. Before I re-sent the patch with the explanation, I wanted to make sure I fully
understood your concerns.

Regards,

K. Y

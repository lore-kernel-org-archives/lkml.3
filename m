Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaH2ROA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:14:00 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:29387
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753268AbaH2RN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:13:58 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>, Dexuan Cui <decui@microsoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: RE: [hyperv] BUG: unable to handle kernel paging request at
 ffff8801f5bc7cbb (netvsc_select_queue)
Thread-Topic: [hyperv] BUG: unable to handle kernel paging request at
 ffff8801f5bc7cbb (netvsc_select_queue)
Thread-Index: AQHPw2wO6MHucssNGk6ZrACVaHo57Jvn0EpQ
Date: Fri, 29 Aug 2014 17:13:55 +0000
Message-ID: <2028bb06104a4e2fafdb2e266a064aaf@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140829093141.GC11445@sucs.org>
In-Reply-To: <20140829093141.GC11445@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199003)(377454003)(13464003)(51704005)(77096002)(66066001)(86362001)(21056001)(76482001)(4396001)(106356001)(80022001)(95666004)(79102001)(1511001)(74662001)(99286002)(87936001)(74502001)(77982001)(86612001)(92566001)(81542001)(76576001)(85852003)(107046002)(54356999)(83072002)(33646002)(106116001)(74316001)(19580405001)(83322001)(64706001)(85306004)(90102001)(108616004)(101416001)(46102001)(20776003)(81342001)(2421001)(76176999)(105586002)(19580395003)(50986999)(31966008)(2656002)(99396002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Friday, August 29, 2014 2:32 AM
> To: Dexuan Cui
> Cc: KY Srinivasan; Greg Kroah-Hartman; Haiyang Zhang;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; David Miller; Daniel Borkmann
> Subject: [hyperv] BUG: unable to handle kernel paging request at
> ffff8801f5bc7cbb (netvsc_select_queue)
> 
> While booting a 10 vcpu system with a post v3.17-rc2 kernel with the
> "Drivers: hv: vmbus: Eliminate calls to BUG_ON()",  "Drivers: hv: vmbus:
> Miscellaneous cleanup" patches and debugging/verification config options on
> I'm seeing the following:

Were you changing the MTU when this occurred?

Regards,

K. Y

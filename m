Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaLVC4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:56:16 -0500
Received: from mail-by2on0148.outbound.protection.outlook.com ([207.46.100.148]:44768
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753733AbaLVC4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:56:14 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jeremiah Mahler <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQGqmcizaS/V/Z90+9ZdsIRkHnfZyYFCmAgAAEkQCAAsHi8IAAETiAgAAEL5A=
Date: Mon, 22 Dec 2014 02:56:11 +0000
Message-ID: <BN1PR06MB070D9DC501F22048B9EAB4ED1560@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418896856-15766-1-git-send-email-dudl@cypress.com>
 <20141220071533.GA1139@newt.localdomain> <20141220073154.GB4637@dtor-ws>
 <BN1PR06MB0701C428956C2E7F7A1DD76D1560@BN1PR06MB070.namprd06.prod.outlook.com>
 <20141222023959.GA30082@dtor-ws>
In-Reply-To: <20141222023959.GA30082@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1079;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1079;
x-forefront-prvs: 0433DB2766
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(41574002)(24454002)(164054003)(51164003)(13464003)(189002)(199003)(99396003)(50986999)(76176999)(76576001)(74316001)(21056001)(66066001)(2656002)(87936001)(19580395003)(19580405001)(54606007)(31966008)(64706001)(40100003)(105586002)(106356001)(20776003)(99286002)(120916001)(54356999)(77156002)(62966003)(110136001)(4396001)(97736003)(93886004)(107046002)(54206007)(46102003)(2950100001)(2900100001)(33656002)(86362001)(68736005)(102836002)(101416001)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1079;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2014 02:56:11.7724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0601MB1079
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got it.
Thanks, Dmitry.

Dudley

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2014?12?22? 10:40
> To: Dudley Du
> Cc: Jeremiah Mahler; rydberg@euromail.se; bleung@google.com; David Solda;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v16 00/12] input: cyapa: instruction of cyapa patches
>
> Hi Dudley,
>
> On Mon, Dec 22, 2014 at 02:09:36AM +0000, Dudley Du wrote:
> > Thanks, Dmitry and Jeremiah,
> >
> > I reproduced this issue in my side when putting fingers on trackpad when system
> booting up.
> > It only happened on gen3 trackpad device.
> > The root cause is, for gen3 TP, the cyapa->ops->sort_empty_output_data is not
> set, so when cyapa->input is not set,
> > the interrupt process should be passed, but since the logica error, it's not, so this
> issue happen.
> >
> > The fix code should be as below.
> > I will correct it and resubmited the patches.
>
> Please hold off resubmitting the patches just yet, let me go over the
> last version you posted.
>
> Thanks!
>
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

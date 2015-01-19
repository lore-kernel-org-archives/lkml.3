Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbbASByZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:54:25 -0500
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:44173
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179AbbASByY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:54:24 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jeremiah Mahler <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQMVaNhhWk2YsQlEKcvatkrYe+UpzEImWAgAAPUQCAAV8BgIABIe3A
Date: Mon, 19 Jan 2015 01:54:21 +0000
Message-ID: <BN1PR06MB07059AE510C95932242461FD14A0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <20150117104415.GA2083@hudson.localdomain>
 <20150117113904.GA2133@hudson.localdomain> <20150118083521.GF15720@dtor-ws>
In-Reply-To: <20150118083521.GF15720@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [140.207.206.26]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN3PR0601MB1074;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1074;
x-forefront-prvs: 046164D5C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51164003)(13464003)(24454002)(51704005)(45984002)(189002)(164054003)(54356999)(97736003)(122556002)(87936001)(54606007)(66066001)(64706001)(77156002)(76576001)(2501002)(40100003)(50986999)(46102003)(19580405001)(86362001)(19580395003)(2201001)(62966003)(93886004)(76176999)(74316001)(102836002)(33656002)(2950100001)(101416001)(54206007)(92566002)(2656002)(15975445007)(106356001)(68736005)(105586002)(99286002)(2900100001)(106116001)(107886001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0601MB1074;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2015 01:54:21.1033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0601MB1074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Thank you very much.

Thanks,
Dudley

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2015?1?18? 16:35
> To: Jeremiah Mahler; Dudley Du; rydberg@euromail.se; bleung@google.com;
> David Solda; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
>
> On Sat, Jan 17, 2015 at 03:39:04AM -0800, Jeremiah Mahler wrote:
> > Dudley,
> >
> > On Sat, Jan 17, 2015 at 02:44:15AM -0800, Jeremiah Mahler wrote:
> > > Dudley,
> > >
> > > Your patch series applies without issue but unfortunately I
> > > could not test them because I ran in to a bug created by someone
> > > elses patch (not yours) [1].
> > >
> > >   [1]: https://lkml.org/lkml/2015/1/17/24
> > >
> > > Once that issue gets resolved I would be happy to test your patch
> > > series.
> > >
> >
> > If I go back to linux-next 20150112 I can avoid the drm/i915 bug.
> > Then, with this patch series applied, everything works well.
> > Suspend/resume work, and the touchpad operates as expected.
> >
> > Tested-by: Jeremiah Mahler <jmmahler@gmail.com>
>
> OK, I believe that the code is in good shape now, so I queued all
> patches for 3.20 (currently in my 'next' branch and should show in
> linux-next soon). Any subsequent improvements to the code
> should be relative to this series.
>
> Jeremiah, thank you for testing the patches; Dudley thank you for your
> patience with the process.
>
> Thanks.
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

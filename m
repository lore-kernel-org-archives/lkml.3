Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbbAVJ64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:58:56 -0500
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:37712
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751299AbbAVJ6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:58:44 -0500
From: Dudley Du <dudl@cypress.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Jeremiah Mahler <jmmahler@gmail.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect
 type in assiggment
Thread-Topic: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect
 type in assiggment
Thread-Index: AQHQNg/VldRbzOjyhkSgK7N8HgJIbJzL4EaAgAAGioCAAADQ0A==
Date: Thu, 22 Jan 2015 09:58:42 +0000
Message-ID: <BN1PR06MB070D1B27364DA910A96F263D1490@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1421909406-1240-1-git-send-email-dudl@cypress.com>
 <20150122093129.GA7133@hudson.localdomain> <20150122095453.GL6507@mwanda>
In-Reply-To: <20150122095453.GL6507@mwanda>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [140.207.206.26]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR06MB070;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB070;
x-forefront-prvs: 0464DBBBC4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(11905935001)(51164003)(189002)(24454002)(13464003)(99286002)(101416001)(76176999)(106356001)(107886001)(66066001)(86362001)(97736003)(92566002)(105586002)(106116001)(2201001)(15395725005)(64706001)(54356999)(54606007)(50986999)(19580395003)(19580405001)(77156002)(87936001)(2656002)(74316001)(68736005)(2900100001)(102836002)(15975445007)(54206007)(122556002)(33656002)(2950100001)(2501002)(46102003)(40100003)(62966003)(76576001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB070;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2015 09:58:42.7843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR06MB070
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: 2015?1?22? 17:55
> To: Jeremiah Mahler; Dudley Du; dmitry.torokhov@gmail.com;
> rydberg@euromail.se; bleung@google.com; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect type in
> assiggment
>
> On Thu, Jan 22, 2015 at 01:31:29AM -0800, Jeremiah Mahler wrote:
> > I wasn't able to reproduce the sparse warning.  Was it for a specific
> > architecture?  Perhaps include a link to the email sent by the kbuild
> > test robot.
>
> You need to add a "CF=-D__CHECK_ENDIAN__" to turn these on.
>
> make C=2 CF=-D__CHECK_ENDIAN__

Yes, thanks.
I verified it locally, no issue found currently.

>
> http://lwn.net/Articles/205624/
>
> regards,
> dan carpenter


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

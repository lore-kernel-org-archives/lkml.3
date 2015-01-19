Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbbASBuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:50:18 -0500
Received: from mail-by2on0117.outbound.protection.outlook.com ([207.46.100.117]:55193
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179AbbASBuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:50:16 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, David Solda <dso@cypress.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQMVaNhhWk2YsQlEKcvatkrYe+UpzEImWAgAB54oCAAE/eAIABxJyw
Date: Mon, 19 Jan 2015 01:50:11 +0000
Message-ID: <BN1PR06MB0706B2EAB238F68A18F2DC4D14A0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <20150117104415.GA2083@hudson.localdomain>
 <0F1DD2F3-F620-4161-A406-43C8F56A1304@cypress.com>
 <20150117224620.GA2855@hudson.localdomain>
In-Reply-To: <20150117224620.GA2855@hudson.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [140.207.206.26]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR0601MB1087;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0601MB1087;
x-forefront-prvs: 046164D5C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(189002)(51164003)(199003)(164054003)(24454002)(51704005)(122556002)(86362001)(62966003)(2900100001)(2950100001)(77156002)(40100003)(76576001)(101416001)(87936001)(19580405001)(74316001)(66066001)(2656002)(92566002)(105586002)(99286002)(54206007)(19580395003)(93886004)(97736003)(68736005)(64706001)(102836002)(54356999)(46102003)(106356001)(33656002)(54606007)(50986999)(106116001)(76176999);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0601MB1087;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2015 01:50:11.7389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0601MB1087
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

Thanks.
If there is something that I could do, please let me know.

Thanks,
Dudley

> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: 2015?1?18? 6:46
> To: David Solda
> Cc: Dudley Du; dmitry.torokhov@gmail.com; rydberg@euromail.se;
> bleung@google.com; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
>
> Dave,
>
> On Sat, Jan 17, 2015 at 06:00:29PM +0000, David Solda wrote:
> > Can we just reverse the prior change that caused the bug, or are you saying that
> the owner of the prior patch has to fix it?
> >
> > Dave
> >
>
> I tried to revert the patch but it didn't do so cleanly.
>
>   git revert ea2c67bb4aff
>
> So I just reverted back to next-20150112.
>
>   git reset --hard next-20150112
>
> I hope the owner of the prior patch responds promptly and fixes their
> bug.  But for the time being the cyapa patch series works when that
> other bug is avoided.
>
> If you have any suggestions, let me know.
>
> --
> - Jeremiah Mahler

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

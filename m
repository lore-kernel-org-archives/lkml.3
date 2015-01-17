Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbbAQTea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 14:34:30 -0500
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:12579
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751348AbbAQTe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 14:34:27 -0500
X-Greylist: delayed 3606 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2015 14:34:27 EST
From: David Solda <dso@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: Dudley Du <dudl@cypress.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQMVaQ/56jTavvUEucirYXn2E7N5zEImWAgAB542U=
Date: Sat, 17 Jan 2015 18:00:29 +0000
Message-ID: <0F1DD2F3-F620-4161-A406-43C8F56A1304@cypress.com>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>,<20150117104415.GA2083@hudson.localdomain>
In-Reply-To: <20150117104415.GA2083@hudson.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:1010:b00e:1e2a:114b:6ad6:cbcf:838f]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dso@cypress.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR06MB072;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB072;
x-forefront-prvs: 04599F3534
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(24454002)(51164003)(377454003)(189002)(110136001)(97736003)(46102003)(36756003)(102836002)(15975445007)(68736005)(54356999)(76176999)(50986999)(1411001)(2900100001)(64706001)(19580395003)(19580405001)(2656002)(87936001)(83716003)(122556002)(33656002)(82746002)(105586002)(40100003)(101416001)(106356001)(2950100001)(106116001)(99286002)(92566002)(86362001)(62966003)(77156002)(104396002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB072;H:BN3PR0601MB1074.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2015 18:00:29.5944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR06MB072
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB151;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we just reverse the prior change that caused the bug, or are you saying that the owner of the prior patch has to fix it?

Dave



> On Jan 17, 2015, at 2:44 AM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
>
> Dudley,
>
> Your patch series applies without issue but unfortunately I
> could not test them because I ran in to a bug created by someone
> elses patch (not yours) [1].
>
>  [1]: https://lkml.org/lkml/2015/1/17/24
>
> Once that issue gets resolved I would be happy to test your patch
> series.
>
>> On Fri, Jan 16, 2015 at 02:34:03PM +0800, Dudley Du wrote:
>> V18 patches have below updates, details of other updates see history list:
>> 1) Fix 'cyapa_runtime_suspend' undeclared compiling issue in latest
>>   kernel-next source code. Verified on next-20150114 with make C=1.
>> 2) Optimize enter bootloader failed for some chipset takes longer time issue.
> [...]
>
> --
> - Jeremiah Mahler

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

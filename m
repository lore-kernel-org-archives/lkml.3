Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaLEBrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:47:52 -0500
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:13343
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754717AbaLEBru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:47:50 -0500
From: Dudley Du <dudl@cypress.com>
To: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
CC: Jeremiah Mahler <jmmahler@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Solda <dso@cypress.com>
Subject: RE: [PATCH v12 01/19] input: cyapa: modify code to following kernel
 code style
Thread-Topic: [PATCH v12 01/19] input: cyapa: modify code to following kernel
 code style
Thread-Index: AQLSNRra1jZVB9nM0+wOVR3Z+Zb0TgHHg1DRAmgH20uaWSRXAIAAxZMAgACEFUA=
Date: Fri, 5 Dec 2014 01:32:19 +0000
Message-ID: <BN1PR06MB070B39C85B5299175E344D7D1790@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
 <1417599025-21681-2-git-send-email-dudley.dulixin@gmail.com>
 <20141204045735.GA5362@newt.localdomain>
 <CO1PR06MB078B7C0303567890795B94BD1780@CO1PR06MB078.namprd06.prod.outlook.com>
 <20141204173212.GA3092@dtor-ws>
In-Reply-To: <20141204173212.GA3092@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1077;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0601MB1077;
x-forefront-prvs: 04163EF38A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(45984002)(199003)(164054003)(51704005)(13464003)(51164003)(24454002)(189002)(41574002)(2501002)(93886004)(110136001)(107046002)(106116001)(106356001)(105586002)(99286002)(77156002)(62966003)(74316001)(76576001)(4396001)(21056001)(40100003)(122556002)(46102003)(2351001)(97736003)(68736005)(31966008)(101416001)(19580395003)(54206007)(33656002)(19580405001)(66066001)(99396003)(20776003)(64706001)(120916001)(54606007)(87936001)(50986999)(2656002)(76176999)(54356999)(86362001)(92566001)(102836002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0601MB1077;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Thank you very much for the effort.
I will re-post the series based on the your updated next branch when it ready.

Thanks,
Dudley

> -----Original Message-----
> From: dmitry.torokhov@gmail.com [mailto:dmitry.torokhov@gmail.com]
> Sent: 2014?12?5? 1:32
> To: Dudley Du
> Cc: Jeremiah Mahler; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v12 01/19] input: cyapa: modify code to following kernel code
> style
>
> Dudley, Jeremiah,
>
> On Thu, Dec 04, 2014 at 05:54:43AM +0000, Dudley Du wrote:
> > Jeremiah,
> >
> > I didn't submitted this fix patch, but Dmitry has been helping apply the fix patch
> quickly, maybe todoay or tommorrow.
>
> The patches that I apply for the next merge window should appear first
> in my 'next' branch in
>
> git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
>
> and then in the linux-next and eventually in mainline.
>
> >
> > For the pathces that I made were worked based off of kernel mainline.
>
> I resolved the conflicts and applied this 1/19 patch, next time you are
> re-posting the series could you please base them off my 'next' branch?
> It will help me applhy them much more easily.
>
> Thanks!
>
> --
> Dmitry

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

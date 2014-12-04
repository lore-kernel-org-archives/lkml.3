Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaLDFyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 00:54:49 -0500
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:7129
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750724AbaLDFys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 00:54:48 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH v12 01/19] input: cyapa: modify code to following kernel
 code style
Thread-Topic: [PATCH v12 01/19] input: cyapa: modify code to following kernel
 code style
Thread-Index: AQLSNRra1jZVB9nM0+wOVR3Z+Zb0TgHHg1DRAmgH20uaWSRXAA==
Date: Thu, 4 Dec 2014 05:54:43 +0000
Message-ID: <CO1PR06MB078B7C0303567890795B94BD1780@CO1PR06MB078.namprd06.prod.outlook.com>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
 <1417599025-21681-2-git-send-email-dudley.dulixin@gmail.com>
 <20141204045735.GA5362@newt.localdomain>
In-Reply-To: <20141204045735.GA5362@newt.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR06MB079;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR06MB079;
x-forefront-prvs: 041517DFAB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(164054003)(51164003)(24454002)(13464003)(51704005)(199003)(189002)(106116001)(120916001)(99396003)(106356001)(76576001)(50986999)(31966008)(74316001)(76176999)(54356999)(99286002)(107046002)(95666004)(19580395003)(20776003)(54206007)(68736005)(122556002)(64706001)(54606007)(19580405001)(40100003)(66066001)(62966003)(110136001)(1411001)(77156002)(2656002)(15975445006)(92726001)(105586002)(21056001)(4396001)(87936001)(86362001)(33656002)(92566001)(101416001)(46102003)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR06MB079;H:CO1PR06MB078.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

I didn't submitted this fix patch, but Dmitry has been helping apply the fix patch quickly, maybe todoay or tommorrow.

For the pathces that I made were worked based off of kernel mainline.

Thanks,
Dudley

> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: 2014?12?4? 12:58
> To: Dudley Du
> Cc: linux-kernel@vger.kernel.org; dmitry.torokhov@gmail.com
> Subject: Re: [PATCH v12 01/19] input: cyapa: modify code to following kernel code
> style
>
> Dudley,
>
> On Wed, Dec 03, 2014 at 05:30:07PM +0800, Dudley Du wrote:
> > This patch modified the code to fix the patch check warning issue with latest
> > checkpatch.sh tool, and also changed the return variable name from "ret" to
> > "error" when there is only one error path to follow code style.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> > ---
> >  drivers/input/mouse/cyapa.c | 162 ++++++++++++++++++++++----------------------
> >  1 file changed, 80 insertions(+), 82 deletions(-)
> >
> > diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> > index b409c3d..c9fdf6d 100644
> > --- a/drivers/input/mouse/cyapa.c
> > +++ b/drivers/input/mouse/cyapa.c
> [...]
>
> I was hoping to test out your patchset since the patch for the touchpad
> problem [1] still has not appeared in linux-next as of 20141203.
> Unfortunately your patchset does not apply so I can't test it.  Which
> kernel is your work based off of?
>
>   [1]: https://lkml.org/lkml/2014/11/27/684
>
> --
> - Jeremiah Mahler

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

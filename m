Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaLQJvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:51:48 -0500
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:2368
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751115AbaLQJvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:51:44 -0500
X-WSS-ID: 0NGQ01Z-07-ZHU-02
X-M-MSG: 
Message-ID: <1418808397.2582.34.camel@kxue-X58A-UD3R>
Subject: Re: [PATCH 3/3] acpi:lpss:Refine lpss codes to fit acpi soc.
From: Ken Xue <Ken.Xue@amd.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 17 Dec 2014 17:26:37 +0800
In-Reply-To: <CAHp75VfoMs-A-6UQurcNsNOCcpgtGL9BjhEPK6j9CET+v=CgGg@mail.gmail.com>
References: <1418267151-5650-1-git-send-email-Ken.Xue@amd.com>
	 <CAHp75VfoMs-A-6UQurcNsNOCcpgtGL9BjhEPK6j9CET+v=CgGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ken.Xue@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(377424004)(377454003)(51704005)(24454002)(199003)(86362001)(19580405001)(77156002)(64706001)(68736005)(20776003)(107046002)(33646002)(76176999)(84676001)(62966003)(19580395003)(120916001)(77096005)(2950100001)(46102003)(23676002)(106466001)(97736003)(89996001)(4396001)(87936001)(101416001)(105586002)(99396003)(92566001)(50466002)(110136001)(47776003)(103116003)(50986999)(21056001)(50226001)(33716001)(31966008)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB206;
X-Forefront-PRVS: 042857DBB5
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 12:27 +0200, Andy Shevchenko wrote:
> On Thu, Dec 11, 2014 at 5:05 AM, Ken Xue <Ken.Xue@amd.com> wrote:
> 
> Make a commit message not empty.
> 
[ken]got it.

> > Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> > ---
> >  drivers/acpi/acpi_lpss.c | 566 ++++++++++++++++++-----------------------------
> >  1 file changed, 221 insertions(+), 345 deletions(-)
> >
> > -static int acpi_lpss_platform_notify(struct notifier_block *nb,
> > -                                    unsigned long action, void *data)
> 
> Could it be just a part of this file? It seems for me that AMD doesn't
> have anything specific which requires to have a dedicated power
> domain. Am I wrong?
> 
[Ken] AMD does not have any specific PM domain now. But i believe it is
a good and necessary feature for low power management. and AMD will have
similar HW design. so, can you share a reason to keep it as a part of
this file?



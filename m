Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbaLJFKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 00:10:10 -0500
Received: from mail-bn1bn0101.outbound.protection.outlook.com ([157.56.110.101]:5392
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750708AbaLJFKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 00:10:08 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v13 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v13 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQE5FvskoYLACK5EqARcb2HrTKN5yIN0cAgAAP4yA=
Date: Wed, 10 Dec 2014 05:10:04 +0000
Message-ID: <BN1PR06MB0705BA630BFB68AB0F53992D1620@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
 <20141210041018.GD4173@hudson.localdomain>
In-Reply-To: <20141210041018.GD4173@hudson.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0601MB1087;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0601MB1087;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(164054003)(189002)(13464003)(24454002)(45984002)(51164003)(87936001)(74316001)(54356999)(54206007)(76176999)(54606007)(50986999)(2656002)(101416001)(33656002)(66066001)(86362001)(19580405001)(92566001)(46102003)(21056001)(20776003)(64706001)(15975445007)(102836002)(99396003)(4396001)(105586002)(120916001)(106116001)(77156002)(62966003)(106356001)(19580395003)(122556002)(107046002)(76576001)(40100003)(99286002)(110136001)(68736005)(31966008)(1411001)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0601MB1087;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

Thank you very much for your review, comments and test.
I will correct the spelling issues in next submit version.

Thanks,
Dudley

> -----Original Message-----
> From: linux-input-owner@vger.kernel.org
> [mailto:linux-input-owner@vger.kernel.org] On Behalf Of Jeremiah Mahler
> Sent: 2014?12?10? 12:10
> To: Dudley Du
> Cc: dmitry.torokhov@gmail.com; rydberg@euromail.se; bleung@google.com;
> David Solda; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v13 00/12] input: cyapa: instruction of cyapa patches
>
> Dudley, all,
>
> On Tue, Dec 09, 2014 at 05:11:32PM +0800, Dudley Du wrote:
> > V13 patches have below updates, details of other updates see history list:
> > 1) Remove all debugfs interface, including read_fw and raw_data interfaces.
> > 2) This patches are made based linux next-20141208.
> >
> [...]
>
> I tested this patch set on an Acer C720 and other than the minor
> problems I pointed out in other emails (CONFIG_CYAPA, spelling) it seems
> to work fine and there are no obvious problems.
>
> Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>
>
> --
> - Jeremiah Mahler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

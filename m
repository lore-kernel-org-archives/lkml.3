Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaLPB2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:28:30 -0500
Received: from mail-by2on0111.outbound.protection.outlook.com ([207.46.100.111]:51199
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750813AbaLPB22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:28:28 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>, David Solda <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v15 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v15 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQGC/AGh80EmvT/0qzqLCEbP4rNJyQsVyAgAC7yUA=
Date: Tue, 16 Dec 2014 01:28:24 +0000
Message-ID: <BN1PR06MB07005FC71EF18F10F595E83D16C0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418624603-19054-1-git-send-email-dudley.dulixin@gmail.com>
 <20141215141023.GB918@newt.localdomain>
In-Reply-To: <20141215141023.GB918@newt.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1075;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0601MB1075;
x-forefront-prvs: 04270EF89C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(51164003)(189002)(199003)(24454002)(51704005)(45984002)(164054003)(106356001)(120916001)(66066001)(99286002)(20776003)(110136001)(107046002)(64706001)(15975445007)(68736005)(97736003)(102836002)(76576001)(31966008)(106116001)(105586002)(74316001)(40100003)(19580405001)(1411001)(54206007)(87936001)(77156002)(76176999)(19580395003)(46102003)(122556002)(4396001)(62966003)(54606007)(33656002)(99396003)(21056001)(54356999)(92566001)(2656002)(50986999)(86362001)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0601MB1075;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2014 01:28:24.7977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0601MB1075
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

No problem. :-)
Thank you very much for your help and so much time on review these patches.
I will fix this issue as soon as possible.

Thanks,
Dudley

> -----Original Message-----
> From: linux-input-owner@vger.kernel.org
> [mailto:linux-input-owner@vger.kernel.org] On Behalf Of Jeremiah Mahler
> Sent: 2014?12?15? 22:10
> To: Dudley Du
> Cc: dmitry.torokhov@gmail.com; rydberg@euromail.se; bleung@google.com;
> David Solda; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v15 00/12] input: cyapa: instruction of cyapa patches
>
> Dudley,
>
> On Mon, Dec 15, 2014 at 02:23:11PM +0800, Dudley Du wrote:
> > V15 patches have below updates, details of other updates see history list:
> > 1) Fix all warning errors of sparse tool when running with "make C=1".
> > 2) Change variable name "unique_str" to "product_id" for clearer meanings.
> >
> >
> > This patch series is aimed to re-design the cyapa driver to support
> > old gen3 trackpad devices and new gen5 trackpad devices in one
> [...]
>
> The patch set still tests fine on my Acer C720.
>
> I went through all the patches and found lots of minor things to fix
> as you would expect from this large amount of code.
>
> I hope you don't get discouraged :-)
>
> --
> - Jeremiah Mahler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

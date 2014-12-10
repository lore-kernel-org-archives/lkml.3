Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaLJC7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:59:21 -0500
Received: from mail-by2on0146.outbound.protection.outlook.com ([207.46.100.146]:25696
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751550AbaLJC7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:59:19 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
 cleanup
Thread-Topic: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
 cleanup
Thread-Index: AQHQE8eay5ykY3ZCeUaN76OLAi2BS5yIHzIg
Date: Wed, 10 Dec 2014 02:58:50 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E9B62F@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:206.191.249.68;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(377454003)(13464003)(51704005)(51914003)(199003)(189002)(2421001)(21056001)(77156002)(55846006)(62966003)(69596002)(6806004)(33656002)(19580395003)(19580405001)(84676001)(23676002)(4396001)(99396003)(120916001)(2656002)(86146001)(87936001)(31966008)(16796002)(50466002)(50986999)(76176999)(86612001)(92566001)(86362001)(46102003)(64706001)(20776003)(47776003)(66066001)(54356999)(81156004)(106466001)(1511001)(106116001)(105606002)(2501002)(97736003)(2561002)(102836002)(68736005)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1212;H:064-smtp-out.microsoft.com;FPR:;SPF:Fail;MLV:sfv;PTR:ErrorRetry;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1212;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB1212;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 206.191.249.68)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1212;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0860;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBA2xTQM003757

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, December 9, 2014 23:48 PM
> To: KY Srinivasan
> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor cleanup
> 
> When someone does 'make' in tools/hv/ issues appear:
> - hv_fcopy_daemon is not being built;
> - lots of compiler warnings.
> 
> This is just a cleanup. Compile-tested by myself on top of linux-next/master.
> 
> Piggyback this series and send "[PATCH 5/5] Tools: hv: do not add redundant
> '/'
>  in hv_start_fcopy()"
> 
> Vitaly Kuznetsov (5):
>   Tools: hv: add mising fcopyd to the Makefile
>   Tools: hv: remove unused bytes_written from kvp_update_file()
>   Tools: hv: address compiler warnings for hv_kvp_daemon.c
>   Tools: hv: address compiler warnings for hv_fcopy_daemon.c
>   Tools: hv: do not add redundant '/' in hv_start_fcopy()
> 
>  tools/hv/Makefile          |  4 ++--
>  tools/hv/hv_fcopy_daemon.c | 10 ++--------
>  tools/hv/hv_kvp_daemon.c   | 29 +++++++++++++----------------
>  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> --
> 1.9.3

Hi Vitaly,
Thanks for the patchset!

Acked-by: Dexuan Cui <decui@microsoft.com>

PS, I added Greg into the TO list.
The hv code in drivers/hv/ and tools/hv/ usually has to go into
Greg's tree first.

-- Dexuan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

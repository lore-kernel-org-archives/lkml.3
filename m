Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbaLJSwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:52:32 -0500
Received: from mail-bn1on0148.outbound.protection.outlook.com ([157.56.110.148]:15808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932501AbaLJSwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:52:31 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH 1/5] Tools: hv: add mising fcopyd to the Makefile
Thread-Topic: [PATCH 1/5] Tools: hv: add mising fcopyd to the Makefile
Thread-Index: AQHQE8eXgaMH8pM900OFvqcKNs29YJyJLTYw
Date: Wed, 10 Dec 2014 18:52:29 +0000
Message-ID: <BY2PR0301MB0711D50C04278F1E0533BDEFA0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
 <1418140103-11854-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-2-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(41574002)(199003)(51704005)(377454003)(189002)(107046002)(122556002)(87936001)(120916001)(2656002)(64706001)(20776003)(40100003)(110136001)(54606007)(99286002)(99396003)(54356999)(50986999)(106116001)(105586002)(4396001)(76176999)(19580405001)(97736003)(106356001)(74316001)(46102003)(54206007)(102836002)(86612001)(19580395003)(92566001)(62966003)(68736005)(77156002)(31966008)(76576001)(101416001)(21056001)(86362001)(33656002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0776;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, December 9, 2014 7:48 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH 1/5] Tools: hv: add mising fcopyd to the Makefile
> 
> fcopyd in missing in the Makefile, add it there.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Thanks!

K. Y

> ---
>  tools/hv/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/hv/Makefile b/tools/hv/Makefile index bd22f78..99ffe61
> 100644
> --- a/tools/hv/Makefile
> +++ b/tools/hv/Makefile
> @@ -5,9 +5,9 @@ PTHREAD_LIBS = -lpthread  WARNINGS = -Wall -Wextra
> CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
> 
> -all: hv_kvp_daemon hv_vss_daemon
> +all: hv_kvp_daemon hv_vss_daemon hv_fcopy_daemon
>  %: %.c
>  	$(CC) $(CFLAGS) -o $@ $^
> 
>  clean:
> -	$(RM) hv_kvp_daemon hv_vss_daemon
> +	$(RM) hv_kvp_daemon hv_vss_daemon hv_fcopy_daemon
> --
> 1.9.3


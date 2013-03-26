Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3CZSr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:47:28 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:33812
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751146Ab3CZSr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:47:27 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz9371I148cI542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
Thread-Topic: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
Thread-Index: AQHOKja3d+L5xLojvEOFQMScGCXgxJi4T2qg
Date: Tue, 26 Mar 2013 18:44:45 +0000
Message-ID: <9c53a9e4e0b04d89a9d9bbc28a8258b4@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(189002)(199002)(52604002)(377454001)(13464002)(31966008)(47446002)(59766001)(80022001)(66066001)(69226001)(47776003)(16676001)(47976001)(76482001)(49866001)(4396001)(54316002)(65816001)(5343655001)(51856001)(46406002)(74662001)(23726001)(5343635001)(63696002)(74502001)(47736001)(79102001)(53806001)(6806001)(20776003)(77982001)(56776001)(33646001)(54356001)(50466001)(50986001)(56816002)(46102001)(24736002)(550254004);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB001;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 079756C6B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, March 26, 2013 11:28 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
> 
> This change fixes a few compile errors:
> 
> hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> hv_vss_daemon.c: In function 'vss_operate':
> hv_vss_daemon.c:66: warning: 'return' with no value, in function returning non-
> void
> hv_vss_daemon.c: In function 'main':
> hv_vss_daemon.c:130: warning: ignoring return value of 'daemon', declared with
> attribute warn_unused_result
> hv_vss_daemon.c: In function 'vss_operate':
> hv_vss_daemon.c:47: warning: 'fs_op' may be used uninitialized in this function
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
Thanks for fixing this.

Acked by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_vss_daemon.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index 9526995..2a03d0b 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -51,7 +51,7 @@ static int vss_operate(int operation)
>  	FILE *file;
>  	char *p;
>  	char *x;
> -	int error;
> +	int error = 0;
> 
>  	switch (operation) {
>  	case VSS_OP_FREEZE:
> @@ -60,11 +60,13 @@ static int vss_operate(int operation)
>  	case VSS_OP_THAW:
>  		fs_op = "-u ";
>  		break;
> +	default:
> +		return -1;
>  	}
> 
> -	file = popen("mount | awk '/^\/dev\// { print $3}'", "r");
> +	file = popen("mount | awk '/^\\/dev\\// { print $3}'", "r");
>  	if (file == NULL)
> -		return;
> +		return -1;
> 
>  	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
>  		x = strchr(p, '\n');
> @@ -128,7 +130,9 @@ int main(void)
>  	int	op;
>  	struct hv_vss_msg *vss_msg;
> 
> -	daemon(1, 0);
> +	if (daemon(1, 0))
> +		return 1;
> +
>  	openlog("Hyper-V VSS", 0, LOG_USER);
>  	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
> 
> 



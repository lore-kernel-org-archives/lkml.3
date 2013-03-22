Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3CVSwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:52:35 -0400
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:34698
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754565Ab3CVSwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:52:34 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I936eI542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: RE: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Thread-Topic: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Thread-Index: AQHOIa9jd5OqsHAaYE6mIfFRqEann5ix7WaAgAArBQA=
Date: Fri, 22 Mar 2013 18:50:17 +0000
Message-ID: <b346c8649eca47cc8ed7846d4f6d74d8@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363375806-19979-1-git-send-email-kys@microsoft.com>
 <20130322161453.GA2767@aepfle.de>
In-Reply-To: <20130322161453.GA2767@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%IOREMAP.NET$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(66066001)(54316002)(79102001)(49866001)(69226001)(47446002)(74502001)(73894001)(4396001)(50986001)(47976001)(6806001)(74662001)(47736001)(31966008)(63696002)(65816001)(77982001)(16676001)(56776001)(20776003)(50466001)(76482001)(53806001)(56816002)(621065001)(47776003)(54356001)(23676001)(51856001)(80022001)(33646001)(46102001)(59766001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB018;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07935ACF08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2MIqmPE015321



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, March 22, 2013 12:15 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com;
> Evgeniy Polyakov
> Subject: Re: [PATCH V2 1/1] Drivers: hv: Add a new driver to support host
> initiated backup
> 
> On Fri, Mar 15, K. Y. Srinivasan wrote:
> 
> > This driver has a user-level component (daemon) that invokes the appropriate
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

Acked-by:  K. Y. Srinivasan <kys@microsoft.com>


> 
> --- a/tools/hv/hv_vss_daemon.c	2013-03-22 17:06:41.000000000 +0100
> +++ b/tools/hv/hv_vss_daemon.c	2013-03-22 17:09:41.000000000 +0100
> @@ -51,7 +51,7 @@ static int vss_operate(int operation)
>  	FILE *file;
>  	char *p;
>  	char *x;
> -	int error;
> +	int error = -1;
> 
>  	switch (operation) {
>  	case VSS_OP_FREEZE:
> @@ -60,11 +60,13 @@ static int vss_operate(int operation)
>  	case VSS_OP_THAW:
>  		fs_op = "-u ";
>  		break;
> +	default:
> +		goto out;
>  	}
> 
> -	file = popen("mount | awk '/^\/dev\// { print $3}'", "r");
> +	file = popen("mount | awk '/^\\/dev\\// { print $3}'", "r");
>  	if (file == NULL)
> -		return;
> +		goto out;
> 
>  	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
>  		x = strchr(p, '\n');
> @@ -82,6 +84,7 @@ static int vss_operate(int operation)
>  	syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
>  	error = system(cmd);
> 
> +out:
>  	return error;
>  }
> 
> @@ -128,7 +131,9 @@ int main(void)
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

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

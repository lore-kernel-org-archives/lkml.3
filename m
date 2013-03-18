Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3CRQw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:52:56 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:52227
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753701Ab3CRQwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:52:53 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: Notify the host of permanent hot-add
 failures
Thread-Topic: [PATCH 1/1] Drivers: hv: Notify the host of permanent hot-add
 failures
Thread-Index: AQHOI4IeNnp8wu86w0mn80jGVi2Hu5irkl0g
Date: Mon, 18 Mar 2013 16:49:50 +0000
Message-ID: <b3f4ab80e0a94364a307902d7cc12969@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363576067-30758-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1363576067-30758-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(189002)(13464002)(51704002)(377454001)(74662001)(47776003)(31966008)(50986001)(56816002)(66066001)(1511001)(69226001)(16676001)(23726001)(4396001)(6806001)(54356001)(65816001)(47736001)(46102001)(33646001)(76482001)(63696002)(79102001)(80022001)(77982001)(47976001)(53806001)(54316002)(20776003)(56776001)(51856001)(5343635001)(46406002)(59766001)(50466001)(49866001)(74502001)(47446002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB011;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07891BF289
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Sunday, March 17, 2013 11:08 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH 1/1] Drivers: hv: Notify the host of permanent hot-add failures
> 
> If memory hot-add fails with the error -EEXIST, then this is a permanent
> failure. Notify the host this information, so the host will not attempt
> hot-add again. If the failure were a transient failure, host will attempt
> a hot-add after some delay.

Greg,

Please drop this patch; I am going to resend this as part of the earlier balloon driver patches I had sent.

Regards,

K. Y
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/hv_balloon.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 71655b4..d2ed673 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -583,6 +583,16 @@ static void hv_mem_hot_add(unsigned long start,
> unsigned long size,
> 
>  		if (ret) {
>  			pr_info("hot_add memory failed error is %d\n", ret);
> +			if (ret == -EEXIST) {
> +				/*
> +				 * This error indicates that the error
> +				 * is not a transient failure. This is the
> +				 * case where the guest's physical address map
> +				 * precludes hot adding memory. Stop all further
> +				 * memory hot-add.
> +				 */
> +				do_hot_add = false;
> +			}
>  			has->ha_end_pfn -= HA_CHUNK;
>  			has->covered_end_pfn -=  processed_pfn;
>  			break;
> @@ -842,11 +852,14 @@ static void hot_add_req(struct work_struct *dummy)
>  		rg_sz = region_size;
>  	}
> 
> -	resp.page_count = process_hot_add(pg_start, pfn_cnt,
> -					rg_start, rg_sz);
> +	if (do_hot_add)
> +		resp.page_count = process_hot_add(pg_start, pfn_cnt,
> +						rg_start, rg_sz);
>  #endif
>  	if (resp.page_count > 0)
>  		resp.result = 1;
> +	else if (!do_hot_add)
> +		resp.result = 1;
>  	else
>  		resp.result = 0;
> 
> --
> 1.7.4.1
> 
> 



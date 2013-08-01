Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3HAOfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:35:20 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:3559 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754889Ab3HAOfS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:35:18 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(51704005)(377454003)(13464003)(189002)(199002)(16406001)(46102001)(53806001)(81542001)(80022001)(74876001)(80976001)(76576001)(74316001)(66066001)(47736001)(33646001)(19580395003)(81342001)(76482001)(83322001)(63696002)(56776001)(51856001)(56816003)(74366001)(65816001)(31966008)(74662001)(4396001)(79102001)(47446002)(54316002)(54356001)(74502001)(19580405001)(76786001)(59766001)(77982001)(47976001)(74706001)(50986001)(76796001)(83072001)(49866001)(69226001)(77096001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Tools: hv: check return value of daemon to fix compiler
 warning.
Thread-Topic: [PATCH] Tools: hv: check return value of daemon to fix
 compiler warning.
Thread-Index: AQHOjrTke5EhfiRIQkOj3zEsGpKksZmAawQQ
Date: Thu, 1 Aug 2013 14:34:34 +0000
Message-ID: <cd624d6beaed42c9aba36143e1a41923@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1375360992-12865-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1375360992-12865-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0925081676
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
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, August 01, 2013 8:43 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH] Tools: hv: check return value of daemon to fix compiler
> warning.
> 
> hv_kvp_daemon.c: In function 'main':
> hv_kvp_daemon.c:1441:8: warning: ignoring return value of 'daemon', declared
> with attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_kvp_daemon.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 657c1d2..418ac55 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1439,7 +1439,8 @@ int main(void)
>  	char *kvp_recv_buffer;
>  	size_t kvp_recv_buffer_len;
> 
> -	daemon(1, 0);
> +	if (daemon(1, 0))
> +		return 1;
>  	openlog("KVP", 0, LOG_USER);
>  	syslog(LOG_INFO, "KVP starting; pid is:%d", getpid());
> 
> 
> 




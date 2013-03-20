Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab3CTNJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:09:38 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:55897
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757132Ab3CTNJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:09:36 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: linux-next: manual merge of the akpm tree with the char-misc
 tree
Thread-Topic: linux-next: manual merge of the akpm tree with the char-misc
 tree
Thread-Index: AQHOJSJxhpDFxWmoWEuKKcP4x/C5J5iujceA
Date: Wed, 20 Mar 2013 13:08:59 +0000
Message-ID: <878be14a66284fcda7c8e95c5f677fde@SN2PR03MB061.namprd03.prod.outlook.com>
References: <20130320152007.56de4a48eaf2760ccc07f02b@canb.auug.org.au>
In-Reply-To: <20130320152007.56de4a48eaf2760ccc07f02b@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KROAH.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ARNDB.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANB.AUUG.ORG.AU$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(13464002)(189002)(199002)(51704002)(80022001)(50986001)(47976001)(53806001)(44976002)(79102001)(46406002)(16676001)(66066001)(59766001)(47776003)(69226001)(76482001)(63696002)(74502001)(77982001)(54316002)(56776001)(50466001)(6806001)(20776003)(74662001)(47446002)(4396001)(54356001)(23726001)(56816002)(31966008)(49866001)(33646001)(65816001)(51856001)(47736001)(46102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB031;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07915F544A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Wednesday, March 20, 2013 12:20 AM
> To: Andrew Morton
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Haiyang Zhang; KY
> Srinivasan; Greg KH; Arnd Bergmann
> Subject: linux-next: manual merge of the akpm tree with the char-misc tree
> 
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> include/linux/hyperv.h between commit 96dd86fa5881 ("Drivers: hv: Add a
> new driver to support host initiated backup") from the char-misc  tree
> and commit "drivers/video: add Hyper-V Synthetic Video Frame Buffer
> Driver" from the akpm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen,


K. Y
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc include/linux/hyperv.h
> index 95d0850,a460ee4..0000000
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@@ -1310,13 -1253,16 +1310,25 @@@ void vmbus_driver_unregister(struct
> hv_
>   		}
> 
>   /*
>  + * VSS (Backup/Restore) GUID
>  + */
>  +#define HV_VSS_GUID \
>  +	.guid = { \
>  +			0x29, 0x2e, 0xfa, 0x35, 0x23, 0xea, 0x36, 0x42, \
>  +			0x96, 0xae, 0x3a, 0x6e, 0xba, 0xcb, 0xa4,  0x40 \
>  +		}
> ++
> ++/*
> +  * Synthetic Video GUID
> +  * {DA0A7802-E377-4aac-8E77-0558EB1073F8}
> +  */
> + #define HV_SYNTHVID_GUID \
> + 	.guid = { \
> + 			0x02, 0x78, 0x0a, 0xda, 0x77, 0xe3, 0xac, 0x4a, \
> + 			0x8e, 0x77, 0x05, 0x58, 0xeb, 0x10, 0x73, 0xf8 \
> + 		}
> +
> +
>   /*
>    * Common header for Hyper-V ICs
>    */


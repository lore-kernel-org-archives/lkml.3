Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab3CDOPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:15:35 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:12097
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757845Ab3CDOPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:15:33 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 0/3] Drivers: hv 
Thread-Topic: [PATCH 0/3] Drivers: hv 
Thread-Index: AQHODVIuVPzr/yIiA06A7EpNQJzmiJiVqceg
Date: Mon, 4 Mar 2013 14:12:44 +0000
Message-ID: <f0040812fcdc4b7c8f0c1289c634a9c3@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1361136655-30979-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1361136655-30979-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(199002)(189002)(13464002)(51704002)(56816002)(74502001)(47446002)(65816001)(16676001)(54316002)(6806001)(53806001)(59766001)(44976002)(31966008)(74662001)(33646001)(46102001)(49866001)(47736001)(5343635001)(51856001)(77982001)(4396001)(50466001)(63696002)(56776001)(66066001)(54356001)(47976001)(76482001)(46406002)(47776003)(20776003)(50986001)(1511001)(79102001)(23726001)(80022001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB020;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0775716B9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Sunday, February 17, 2013 4:31 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH 0/3] Drivers: hv
> 
> The patch for the vmbus drivers properly cleans up the channel state on receipt
> of the "offer rescind" message. The balloon driver patches permit the execution
> of both "balloon up" operation as well as the "hot-add" operation in separate
> execution contexts. This allows the balloon driver to be more responsive both
> in terms of reporting pressure to the host as well as responding to the requests
> from the host.
> 
> K. Y. Srinivasan (3):
>   Drivers: hv: vmbus: Handle channel rescind message correctly
>   Drivers: hv: balloon: Execute balloon inflation in a separate context
>   Drivers: hv: balloon: Execute hot-add code in a separate context
> 
>  drivers/hv/channel_mgmt.c |   11 +++++++
>  drivers/hv/hv_balloon.c   |   74 ++++++++++++++++++++++++++++----------------
> -
>  2 files changed, 57 insertions(+), 28 deletions(-)
> 
> --
> 1.7.4.1

Greg,

Please drop this set; I will resend these with some fixes.

Regards,

K. Y
> 
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3DWUx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:53:56 -0400
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:37119
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754725Ab3DWUxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:53:54 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/5] [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
Thread-Topic: [PATCH 1/5] [PATCH 1/3] Tools: hv: fix warnings in
 hv_vss_daemon
Thread-Index: AQHOQGDg30eMBfzHL0ONQFDiEqVfzZjkQ14AgAAEoUA=
Date: Tue, 23 Apr 2013 20:52:32 +0000
Message-ID: <41b7f11342274aa79c5e7a360a052262@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1366750685-32626-1-git-send-email-kys@microsoft.com>
 <1366750720-32667-1-git-send-email-kys@microsoft.com>
 <20130423203516.GA2894@kroah.com>
In-Reply-To: <20130423203516.GA2894@kroah.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(199002)(189002)(24454001)(377454001)(51704004)(51856001)(56816002)(23726002)(44976003)(69226001)(47976001)(33646001)(31966008)(65816001)(54356001)(63696002)(16676001)(53806001)(74662001)(47446002)(4396001)(80022001)(59766001)(81542001)(47776003)(74502001)(46406003)(46102001)(50986001)(79102001)(20776003)(77982001)(56776001)(76482001)(66066001)(49866001)(81342001)(47736001)(50466001)(54316002)(6806003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB020;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 08252193F3
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, April 23, 2013 4:35 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/5] [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
> 
> On Tue, Apr 23, 2013 at 01:58:36PM -0700, K. Y. Srinivasan wrote:
> > From: Olaf Hering <olaf@aepfle.de>
> 
> Trailing space :(

Sorry about that.
> 
> But what's really causing me to reject all 5 of these is the Subject:
> 
> The third time's a charm?

I do hope third time is the charm.

Regards,

K. Y
> 
> greg k-h
> 



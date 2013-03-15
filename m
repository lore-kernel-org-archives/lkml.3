Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3COSwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:52:08 -0400
Received: from mail-bn1lp0151.outbound.protection.outlook.com ([207.46.163.151]:39089
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753986Ab3COSwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:52:06 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 0
X-BigFish: PS0(z551biz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH RESEND 0/6] Drivers: hv
Thread-Topic: [PATCH RESEND 0/6] Drivers: hv
Thread-Index: AQHOIan2TzZUQaxB4k6FISf1gm4EgZinGHyQ
Date: Fri, 15 Mar 2013 18:50:35 +0000
Message-ID: <504ab17e96d24473a5001714a109a3dd@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363293537-13389-1-git-send-email-kys@microsoft.com>
 <20130315182100.GA2907@kroah.com>
In-Reply-To: <20130315182100.GA2907@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.93.4]
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
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(51704002)(13464002)(377454001)(76482001)(44976002)(31966008)(47976001)(54356001)(47776003)(33646001)(5343635001)(51856001)(56816002)(53806001)(65816001)(46102001)(6806001)(49866001)(20776003)(4396001)(69226001)(59766001)(50466001)(79102001)(77982001)(23726001)(54316002)(74502001)(56776001)(47736001)(16676001)(50986001)(74662001)(47446002)(80022001)(63696002)(46406002)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB027;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 078693968A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, March 15, 2013 2:21 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH RESEND 0/6] Drivers: hv
> 
> Your subject says "resend", but you don't tell me which version it is?
> I see about 3 different versions of this series, which one should I use?
> 
> Please be specific when sending patches, otherwise I will guess, and I
> usually guess wrong...
> 
> I'm going to drop this, and all other hv patches from you, please resend
> what I haven't applied yet.

I will send all the patches again.

K. Y
> 
> thanks,
> 
> greg k-h
> 



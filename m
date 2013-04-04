Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763749Ab3DDROq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:14:46 -0400
Received: from mail-bn1lp0154.outbound.protection.outlook.com ([207.46.163.154]:52664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763694Ab3DDROo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:14:44 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I936eI542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: scanning for LUNs
Thread-Topic: scanning for LUNs
Thread-Index: AQHOMUdANg7kpflkhkadeeCX7AcjMpjGTF9g
Date: Thu, 4 Apr 2013 17:12:37 +0000
Message-ID: <5c58dfba0d564ed4b6959a0d478268b9@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1365088357-22624-1-git-send-email-kys@microsoft.com>
 <1365088500.2764.8.camel@dabdike>
In-Reply-To: <1365088500.2764.8.camel@dabdike>
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
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(13464002)(199002)(377424002)(377454001)(51704002)(189002)(81342001)(63696002)(51856001)(4396001)(47736001)(54316002)(76482001)(44976002)(74662001)(31966008)(66066001)(50466001)(47976001)(77982001)(47776003)(16676001)(56776001)(20776003)(80022001)(79102001)(81542001)(46406002)(56816002)(23726001)(33646001)(54356001)(69226001)(65816001)(5343655001)(74502001)(47446002)(50986001)(46102001)(6806001)(59766001)(49866001)(53806001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB026;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 08062C429B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Thursday, April 04, 2013 11:15 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: scanning for LUNs
> 
> On Thu, 2013-04-04 at 08:12 -0700, K. Y. Srinivasan wrote:
> > Here is the code snippet for scanning LUNS (drivers/scsi/scsi_scan.c in function
> > __scsi_scan_target()):
> >
> >         /*
> >          * Scan LUN 0, if there is some response, scan further. Ideally, we
> >          * would not configure LUN 0 until all LUNs are scanned.
> >          */
> >         res = scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL);
> >         if (res == SCSI_SCAN_LUN_PRESENT || res ==
> SCSI_SCAN_TARGET_PRESENT) {
> >                 if (scsi_report_lun_scan(starget, bflags, rescan) != 0)
> >
> >
> > So, if we don't get a response while scanning LUN0, we will not use
> > scsi_report_lun_scan().
> > On Hyper-V, the scsi emulation on the host does not treat LUN0 as
> > anything special and we
> > could have situations where the only device under a scsi controller is
> > at a location other than 0
> > or 1. In this case the standard LUN scanning code in Linux fails to
> > detect this device. Is this
> > behaviour expected? Why is LUN0 treated differently here. Looking at
> > the scsi spec, I am not sure
> > if this is what is specified. Any help/guidance will be greatly
> > appreciated.
> 
> Why don't you describe the problem.  We can't scan randomly a bunch of
> LUNs hoping for a response (the space is 10^19).  SAM thinks you use
> LUNW for this, but that's not well supported.  We can't annoy USB
> devices by probing with REPORT LUNS, so conventionally most arrays
> return something for LUN0 even if they don't actually have one (That's
> what the peripheral qualifier codes are supposed to be about).  We
> translate PQ1 and PQ2 to SCSI_SCAN_TARGET_PRESENT, which means no LUN,
> but there is a target to scan here.
> 
> If you're sending back an error to an INQUIRY to LUN0, then you're out
> of spec.  The SCSI standards say:
> 
>         SPC3 6.4.1: In response to an INQUIRY command received by an
>         incorrect logical unit, the SCSI target device shall return the
>         INQUIRY data with the peripheral qualifier set to the value
>         defined in 6.4.2. The INQUIRY command shall return CHECK
>         CONDITION status only when the device server is unable to return
>         the requested INQUIRY data

Thanks James. I will further investigate the issue on our platform.

Regards,

K. Y
> 
> James
> 
> 
> James
> 
> 



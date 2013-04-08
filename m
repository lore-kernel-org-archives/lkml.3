Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222Ab3DHRgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:36:49 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:29588
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934068Ab3DHRgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:36:47 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371Ic89bh936eI542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h947hd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Hannes Reinecke <hare@suse.de>
CC: James Bottomley <jbottomley@parallels.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: scanning for LUNs
Thread-Topic: scanning for LUNs
Thread-Index: AQHOMUdANg7kpflkhkadeeCX7AcjMpjGTF9ggAYfjQCAAC264A==
Date: Mon, 8 Apr 2013 17:34:52 +0000
Message-ID: <12d86cf8a8c84ae787b8be0fa382fa29@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1365088357-22624-1-git-send-email-kys@microsoft.com>
 <1365088500.2764.8.camel@dabdike>
 <5c58dfba0d564ed4b6959a0d478268b9@SN2PR03MB061.namprd03.prod.outlook.com>
 <5162D73E.4000906@suse.de>
In-Reply-To: <5162D73E.4000906@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(51704002)(13464002)(479174001)(377424002)(377454001)(20776003)(44976002)(5343655001)(49866001)(56816002)(50466001)(53806001)(47446002)(81542001)(77982001)(69226001)(74502001)(76482001)(63696002)(59766001)(47976001)(46102001)(47776003)(50986001)(6806001)(4396001)(56776001)(54316002)(33646001)(80022001)(74662001)(31966008)(47736001)(65816001)(23756002)(54356001)(66066001)(79102001)(81342001)(51856001)(16676001)(24736002)(550254004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB014;H:TK5EX14HUBC103.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0810818DA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, April 08, 2013 10:42 AM
> To: KY Srinivasan
> Cc: James Bottomley; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: scanning for LUNs
> 
> On 04/04/2013 07:12 PM, KY Srinivasan wrote:
> >
> >
> >> -----Original Message-----
> >> From: James Bottomley [mailto:jbottomley@parallels.com]
> >> Sent: Thursday, April 04, 2013 11:15 AM
> >> To: KY Srinivasan
> >> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> >> scsi@vger.kernel.org
> >> Subject: Re: scanning for LUNs
> >>
> >> On Thu, 2013-04-04 at 08:12 -0700, K. Y. Srinivasan wrote:
> >>> Here is the code snippet for scanning LUNS (drivers/scsi/scsi_scan.c in
> function
> >>> __scsi_scan_target()):
> >>>
> >>>         /*
> >>>          * Scan LUN 0, if there is some response, scan further. Ideally, we
> >>>          * would not configure LUN 0 until all LUNs are scanned.
> >>>          */
> >>>         res = scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL);
> >>>         if (res == SCSI_SCAN_LUN_PRESENT || res ==
> >> SCSI_SCAN_TARGET_PRESENT) {
> >>>                 if (scsi_report_lun_scan(starget, bflags, rescan) != 0)
> >>>
> >>>
> >>> So, if we don't get a response while scanning LUN0, we will not use
> >>> scsi_report_lun_scan().
> >>> On Hyper-V, the scsi emulation on the host does not treat LUN0 as
> >>> anything special and we
> >>> could have situations where the only device under a scsi controller is
> >>> at a location other than 0
> >>> or 1. In this case the standard LUN scanning code in Linux fails to
> >>> detect this device. Is this
> >>> behaviour expected? Why is LUN0 treated differently here. Looking at
> >>> the scsi spec, I am not sure
> >>> if this is what is specified. Any help/guidance will be greatly
> >>> appreciated.
> >>
> >> Why don't you describe the problem.  We can't scan randomly a bunch of
> >> LUNs hoping for a response (the space is 10^19).  SAM thinks you use
> >> LUNW for this, but that's not well supported.  We can't annoy USB
> >> devices by probing with REPORT LUNS, so conventionally most arrays
> >> return something for LUN0 even if they don't actually have one (That's
> >> what the peripheral qualifier codes are supposed to be about).  We
> >> translate PQ1 and PQ2 to SCSI_SCAN_TARGET_PRESENT, which means no
> LUN,
> >> but there is a target to scan here.
> >>
> >> If you're sending back an error to an INQUIRY to LUN0, then you're out
> >> of spec.  The SCSI standards say:
> >>
> >>         SPC3 6.4.1: In response to an INQUIRY command received by an
> >>         incorrect logical unit, the SCSI target device shall return the
> >>         INQUIRY data with the peripheral qualifier set to the value
> >>         defined in 6.4.2. The INQUIRY command shall return CHECK
> >>         CONDITION status only when the device server is unable to return
> >>         the requested INQUIRY data
> >
> > Thanks James. I will further investigate the issue on our platform.
> >
> Or check if you can use W_LUN for scanning.
> I've done a patchset for this (check the mailing list).
> 
> Using W_LUN is precisely for this type of setup.
> 
> (And would provide me with another scenario for using W_LUNs :-)

Thanks Hannes. What is the status on this patch; is it planned for the next upstream release?

Regards,

K. Y
> 
> Cheers,
> 
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
> 



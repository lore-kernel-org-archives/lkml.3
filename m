Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab3CEDwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:52:22 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.24]:10950 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566Ab3CEDwU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:52:20 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Mar 2013 22:52:19 EST
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH v2] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Topic: [PATCH v2] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Index: AQHOGR8rR1d2Cn5OekKWK9Y81PDGP5iW0euA//+jKXA=
Date: Tue, 5 Mar 2013 03:46:46 +0000
Message-ID: <f2a49f00794e4e2bbd2f2a0201a5b544@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1362434172-25070-1-git-send-email-haiyangz@microsoft.com>
 <20130305011613.GA21499@kroah.com>
In-Reply-To: <20130305011613.GA21499@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(52604002)(13464002)(377454001)(51704002)(24454001)(189002)(199002)(33646001)(66066001)(47976001)(54356001)(51856001)(54316002)(50986001)(65816001)(23726001)(49866001)(47736001)(46102001)(50466001)(80022001)(79102001)(16406001)(47446002)(31966008)(53806001)(63696002)(74502001)(77982001)(47776003)(876001)(20776003)(46406002)(76482001)(5343655001)(4396001)(44976002)(59766001)(56776001)(69226001)(56816002)(74662001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:CH1SR01MB612;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0776C39A48
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Monday, March 04, 2013 8:16 PM
> To: Haiyang Zhang
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org;
> olaf@aepfle.de; jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH v2] video: Add Hyper-V Synthetic Video Frame Buffer
> Driver
> 
> On Mon, Mar 04, 2013 at 01:56:12PM -0800, Haiyang Zhang wrote:
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2951,3 +2951,6 @@
> >  #define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
> >
> >  #define PCI_VENDOR_ID_OCZ		0x1b85
> > +
> > +#define PCI_VENDOR_ID_MICROSOFT		0x1414
> > +#define PCI_DEVICE_ID_HYPERV_VIDEO	0x5353
> 
> Please see the top of this while for why you shouldn't be adding any lines to
> this file.

I will move the defines back to the hyperv_fb.c.
Thanks for pointing this out.

- Haiyang


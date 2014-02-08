Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaBHAZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:25:54 -0500
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:12110
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750868AbaBHAZw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:25:52 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/1] Drivers: hv: vmbus: Extract the mmio information
 from DSDT
Thread-Topic: [PATCH V2 1/1] Drivers: hv: vmbus: Extract the mmio
 information from DSDT
Thread-Index: AQHPHVoNs8GOOKn6JEms3yo7q3iGa5qqe+4AgAARycA=
Date: Sat, 8 Feb 2014 00:25:49 +0000
Message-ID: <bcb6b512044d42718ec8f851fe765e35@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1391048079-13975-1-git-send-email-kys@microsoft.com>
 <20140207232124.GA23544@kroah.com>
In-Reply-To: <20140207232124.GA23544@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.206]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377454003)(51704005)(189002)(199002)(24454002)(13464003)(80022001)(49866001)(47736001)(4396001)(53806001)(65816001)(66066001)(79102001)(74366001)(63696002)(83072002)(85852003)(94316002)(47976001)(50986001)(54356001)(76482001)(31966008)(56776001)(51856001)(83322001)(19580395003)(19580405001)(47446002)(74662001)(74502001)(54316002)(2656002)(92566001)(87266001)(87936001)(85306002)(33646001)(81686001)(46102001)(81816001)(93136001)(69226001)(95416001)(76576001)(86612001)(81342001)(81542001)(76786001)(94946001)(76796001)(74706001)(86362001)(59766001)(93516002)(80976001)(77982001)(90146001)(74316001)(74876001)(56816005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.174.206;FPR:BC1EED11.AE134D9A.37E79F3F.C465F94D.201C2;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, February 07, 2014 3:21 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V2 1/1] Drivers: hv: vmbus: Extract the mmio information
> from DSDT
> 
> On Wed, Jan 29, 2014 at 06:14:39PM -0800, K. Y. Srinivasan wrote:
> > On Gen2 firmware, Hyper-V does not emulate the PCI bus. However, the
> MMIO
> > information is packaged up in DSDT. Extract this information and export it
> > for use by the synthetic framebuffer driver. This is the only driver that
> > needs this currently.
> 
> I don't see a follow-on patch that uses these variables, where is that?

The synthetic framebuffer driver will use this. It will be submitted shortly.

K. Y 
> 
> thanks,
> 
> greg k-h

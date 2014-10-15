Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaJOJWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:22:54 -0400
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:65024
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751468AbaJOJWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:22:53 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2 2/2] hyperv: Implement Time Synchronization using
 host time sample
Thread-Topic: [PATCH v2 2/2] hyperv: Implement Time Synchronization using
 host time sample
Thread-Index: AQHP6EpV0yTtUPFvLUmVTRuWJYo4nZww4UkAgAAArUA=
Date: Wed, 15 Oct 2014 09:21:33 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540C171E@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362404-16284-1-git-send-email-huishao@microsoft.com>
 <20141015091808.GB5300@localhost.localdomain>
In-Reply-To: <20141015091808.GB5300@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.94.23.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(13464003)(189002)(51704005)(377454003)(24454002)(164054003)(77096002)(106116001)(85306004)(97756001)(81156004)(120916001)(2656002)(86612001)(87936001)(6806004)(95666004)(106466001)(47776003)(64706001)(20776003)(92566001)(4396001)(23726002)(85852003)(107046002)(55846006)(84676001)(80022003)(50466002)(46102003)(110136001)(21056001)(92726001)(19580405001)(31966008)(19580395003)(54356999)(86146001)(50986999)(99396003)(68736004)(69596002)(76176999)(86362001)(44976005)(16796002)(46406003)(1411001)(97736003)(33656002)(76482002)(26826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1211;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0365C0E14B
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Richard Cochran [mailto:richardcochran@gmail.com]
> Sent: Wednesday, October 15, 2014 5:18 PM
> To: Thomas Shao
> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH v2 2/2] hyperv: Implement Time Synchronization using
> host time sample
> 
> On Wed, Oct 15, 2014 at 01:40:04AM -0700, Thomas Shao wrote:
> > In current hyper-v time sync service,it only gets the initial clock
> > time from the host. It didn't process the following time samples. This
> > change introduced a module parameter called host_time_sync. If it is
> > set to true, the guest will periodically sychronize it's time with the
> > host clock using host time sample. By default it is disabled, because
> > we still recommend user to configure NTP for time synchronization.
> >
> > Signed-off-by: Thomas Shao <huishao@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> 
> Um, what changed in V2?

In V2, I address all the Dan's comments.

> 
> Thanks,
> Richard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaJOJUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:20:21 -0400
Received: from mail-bl2on0106.outbound.protection.outlook.com ([65.55.169.106]:35773
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751292AbaJOJUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:20:19 -0400
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
Thread-Index: AQHP6EpV0yTtUPFvLUmVTRuWJYo4nZww39IAgAABcDA=
Date: Wed, 15 Oct 2014 09:20:01 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540C16FF@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362404-16284-1-git-send-email-huishao@microsoft.com>
 <20141015091254.GA5300@localhost.localdomain>
In-Reply-To: <20141015091254.GA5300@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.94.23.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(438002)(377454003)(164054003)(189002)(199003)(51914003)(13464003)(51704005)(77096002)(64706001)(47776003)(50466002)(86362001)(4396001)(76482002)(85852003)(85306004)(26826002)(23726002)(20776003)(92726001)(92566001)(84676001)(15975445006)(86612001)(99396003)(55846006)(33656002)(46406003)(95666004)(107046002)(46102003)(86146001)(54356999)(80022003)(1411001)(31966008)(16796002)(87936001)(6806004)(44976005)(19580395003)(19580405001)(50986999)(106466001)(68736004)(69596002)(81156004)(2656002)(110136001)(15202345003)(120916001)(97736003)(76176999)(21056001)(97756001)(106116001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1202;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1202;
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
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Richard Cochran
> Sent: Wednesday, October 15, 2014 5:13 PM
> To: Thomas Shao
> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH v2 2/2] hyperv: Implement Time Synchronization using
> host time sample
> 
> You really need to put John Stultz onto CC.

Will do that next time. Thanks for the reminder.

> 
> Thanks,
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
